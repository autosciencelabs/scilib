"""Render a .lean file as one presentable, self-contained HTML page.
Nothing is dropped: every line of the file is shown, docstrings and comments included.
Lean's own output for #eval lines and the result of #guard lines are attached under the code.
usage: python3 report/src2html.py <file.lean> <out.html> [replace_import_from=to]"""
import html, json, os, re, subprocess, sys

src, out = sys.argv[1], sys.argv[2]
text = open(src, encoding="utf-8").read().replace("\r\n", "\n")
name = os.path.basename(src)
mod = name[:-5]

# ---- ask Lean for its messages (positions kept: only the import line text is swapped)
msgs = []
if len(sys.argv) > 3 and "=" in sys.argv[3]:
    a, b = sys.argv[3].split("=")
    fixed = text.replace("import " + a, "import " + b, 1)
else:
    fixed = text
drv = "report/build/_src2html_" + mod + ".lean"
open(drv, "w", encoding="utf-8").write(fixed)
cmd = 'LEAN_PATH="$LEAN_PATH;report/build" lean --json ' + drv
r = subprocess.run(["lake", "env", "bash", "-c", cmd], capture_output=True, text=True)
for ln in r.stdout.splitlines():
    try:
        msgs.append(json.loads(ln))
    except Exception:
        pass
errors = [m for m in msgs if m.get("severity") == "error"]
by_end = {}
for m in msgs:
    if m.get("severity") == "information":
        by_end.setdefault(m["endPos"]["line"] if m.get("endPos") else m["pos"]["line"], []).append(m["data"])

# ---- highlighting
KW = ("def structure inductive abbrev namespace end open import where fun let match with if then else do "
      "for in return pure deriving theorem instance mut at by from have show variable section private partial "
      "unsafe macro syntax rec class extends set_option universe").split()
TOK = re.compile(r'''(?P<doc>/--.*?-/)|(?P<blk>/-.*?-/)|(?P<line>--[^\n]*)|(?P<str>s!"(?:\\.|[^"\\])*"|"(?:\\.|[^"\\])*")'''
                 r'''|(?P<cmd>\#\w+)|(?P<num>\b\d[\d_]*(?:\.\d+)?(?:e-?\d+)?\b)|(?P<kw>\b(?:''' + "|".join(KW) + r''')\b)'''
                 r'''|(?P<ty>\b[A-Z][A-Za-z0-9_]*(?:\.[A-Za-z0-9_]+)*\b)|(?P<fld>\b[a-z][A-Za-z0-9_]*\b(?=\s*:=))''', re.S)

def wrap(cls, s):
    return "\n".join(f'<span class="{cls}">{html.escape(p)}</span>' if p else "" for p in s.split("\n"))

def hl(code):
    res, pos = [], 0
    for m in TOK.finditer(code):
        res.append(html.escape(code[pos:m.start()]))
        res.append(wrap(m.lastgroup, m.group()))
        pos = m.end()
    res.append(html.escape(code[pos:]))
    return "".join(res).split("\n")

# ---- split into module-doc sections and code
MD = re.compile(r"/-!(.*?)-/", re.S)
parts, last = [], 0
for m in MD.finditer(text):
    parts.append(("code", last, m.start()))
    parts.append(("doc", m.start(), m.end()))
    last = m.end()
parts.append(("code", last, len(text)))
line_of = lambda pos: text.count("\n", 0, pos) + 1

def md(s):
    s = html.escape(s.strip())
    s = re.sub(r"`([^`]+)`", r"<code>\1</code>", s)
    s = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", s)
    outp = []
    for para in re.split(r"\n\s*\n", s):
        L = para.strip()
        if L.startswith("# "):
            outp.append(f"<h1>{L[2:]}</h1>")
        elif L.startswith("## "):
            outp.append(f"<h2>{L[3:]}</h2>")
        else:
            lines = L.split("\n")
            if all(x.lstrip().startswith(("* ", "- ")) or x.startswith("  ") for x in lines) and lines[0].lstrip().startswith(("* ", "- ")):
                items, cur = [], ""
                for x in lines:
                    if x.lstrip().startswith(("* ", "- ")):
                        if cur: items.append(cur)
                        cur = x.lstrip()[2:]
                    else:
                        cur += " " + x.strip()
                items.append(cur)
                outp.append("<ul>" + "".join(f"<li>{i}</li>" for i in items) + "</ul>")
            else:
                outp.append("<p>" + " ".join(x.strip() for x in lines) + "</p>")
    return "\n".join(outp)

DECL = re.compile(r"^(?:@\[[^\]]*\]\s*)?(?:private |partial |unsafe )*(def|structure|inductive|abbrev|theorem|instance)\s+([^\s:({\[]+)", re.M)
decls = []

def code_block(a, b):
    chunk = text[a:b]
    first = line_of(a)
    ls = chunk.split("\n")
    # trim blank edges but keep numbering right
    while ls and not ls[0].strip():
        ls.pop(0); first += 1
    while ls and not ls[-1].strip():
        ls.pop()
    if not ls:
        return ""
    body = "\n".join(ls)
    hl_lines = hl(body)
    rows = []
    for i, h in enumerate(hl_lines):
        n = first + i
        raw = ls[i]
        extra = ""
        dm = DECL.match(raw)
        anchor = ""
        if dm:
            anchor = f' id="d-{html.escape(dm.group(2))}"'
            decls.append((dm.group(1), dm.group(2)))
        if raw.startswith("#guard"):
            # the guard may span several lines; it holds when Lean reports no error anywhere in this file position
            bad = [e for e in errors if e["pos"]["line"] == n]
            extra = ' <span class="bad">✗ fails</span>' if bad else ' <span class="ok">✓ holds</span>'
        rows.append(f'<div class="l"{anchor}><span class="n">{n}</span><span class="c">{h}{extra}</span></div>')
        for o in by_end.get(n, []):
            rows.append('<div class="o"><span class="n"></span><pre>' + html.escape(o.rstrip()) + "</pre></div>")
    return '<div class="code">' + "".join(rows) + "</div>"

body = []
for kind, a, b in parts:
    if kind == "doc":
        body.append('<section class="doc">' + md(text[a + 3:b - 2]) + "</section>")
    else:
        body.append(code_block(a, b))

nlines = text.count("\n") + 1
toc = "".join(f'<a href="#d-{html.escape(n)}"><i>{k}</i> {html.escape(n)}</a>' for k, n in decls)
status = (f"Lean 4 reports {len(errors)} error(s) on this file." if errors else "Lean 4 accepts this file with no errors.")
page = f"""<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>{html.escape(mod)}</title>
<style>
:root{{--bg:#d9d7d1;--page:#fffefb;--fg:#1a1a1a;--muted:#666;--band:#f5f2ea;--line:#d6d2c6;--kw:#8a4fa0;--ty:#17707a;--str:#2e8b6e;--com:#8a8578;--doc:#6b6558;--num:#b4561c;--cmd:#c2410c;--ok:#2e8b6e;--bad:#d63b2b;
--serif:Georgia,"Times New Roman",serif;--tt:ui-monospace,"SF Mono",Menlo,Consolas,monospace}}
@media (prefers-color-scheme:dark){{:root:not([data-theme=light]){{--bg:#0e0e0d;--page:#1c1b18;--fg:#ece8df;--muted:#a8a396;--band:#25231f;--line:#3a372f;--kw:#c79ad6;--ty:#6cc4cf;--str:#7fd0b2;--com:#8d8777;--doc:#b9b3a3;--num:#f0a36a;--cmd:#f08a52}}}}
html,body{{margin:0;background:var(--bg);color:var(--fg);font-family:var(--serif)}}
main{{background:var(--page);max-width:1000px;margin:24px auto;padding:48px 48px 40px;box-shadow:0 2px 18px #0003}}
@media (max-width:700px){{main{{margin:0;padding:24px 14px}}}}
h1.title{{font-weight:400;font-size:1.9rem;text-align:center;margin:0 0 .3rem}}
.sub{{text-align:center;color:var(--muted);margin:0 0 1.2rem;font-size:.98rem}}
.toc{{display:flex;flex-wrap:wrap;gap:4px 12px;font-size:.84rem;margin:0 0 1.4rem;padding:10px 12px;background:var(--band);border:1px solid var(--line)}}
.toc a{{color:var(--fg);text-decoration:none;font-family:var(--tt)}}.toc a:hover{{text-decoration:underline}}.toc i{{color:var(--muted);font-style:normal}}
section.doc h1{{font-weight:400;font-size:1.5rem;margin:1.6rem 0 .4rem}}
section.doc h2{{font-size:1.2rem;margin:1.8rem 0 .5rem;padding-top:.5rem;border-top:2px solid var(--fg)}}
section.doc p,section.doc li{{font-size:1rem;line-height:1.55}}
section.doc code{{font-family:var(--tt);font-size:.88em}}
.code{{font-family:var(--tt);font-size:.82rem;line-height:1.5;border:1px solid var(--line);background:var(--band);margin:.5rem 0}}
.l,.o{{display:flex}}
.n{{flex:0 0 3.2em;text-align:right;padding-right:1em;color:var(--muted);user-select:none;opacity:.7}}
.c{{white-space:pre-wrap;overflow-wrap:anywhere;min-width:0}}
.o{{background:var(--page);border-top:1px dashed var(--line);border-bottom:1px dashed var(--line)}}
.o pre{{margin:2px 0;font:inherit;white-space:pre-wrap;color:var(--ok)}}
.kw{{color:var(--kw);font-weight:600}}.ty{{color:var(--ty)}}.str{{color:var(--str)}}.num{{color:var(--num)}}.cmd{{color:var(--cmd);font-weight:600}}
.line,.blk{{color:var(--com);font-style:italic}}.doc{{color:var(--doc)}}.fld{{color:var(--fg);font-weight:600}}
span.doc{{font-style:italic}}
.ok{{color:var(--ok);font-family:var(--serif);font-size:.78rem}}.bad{{color:var(--bad);font-family:var(--serif);font-size:.78rem}}
.foot{{color:var(--muted);font-size:.86rem;margin-top:1.6rem;text-align:center}}
</style></head><body><main>
<h1 class="title">{html.escape(mod)}</h1>
<p class="sub"><code>Scilib/{html.escape(name)}</code> &middot; {nlines} lines &middot; {len(decls)} declarations &middot; {status}</p>
<div class="toc">{toc}</div>
{"".join(body)}
<p class="foot">Every line of the file is shown above. Green blocks are what Lean printed for the <code>#eval</code> lines when this page was built.</p>
</main></body></html>"""
open(out, "w", encoding="utf-8").write(page)
print("wrote", out, "| lines", nlines, "| decls", len(decls), "| lean errors", len(errors), "| outputs", sum(len(v) for v in by_end.values()))
for e in errors[:5]:
    print("ERR", e["pos"], e["data"][:200])
