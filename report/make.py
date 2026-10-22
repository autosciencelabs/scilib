import re, subprocess, sys, os
src = sys.argv[1]
text = open(src, encoding="utf-8").read().replace("\r\n", "\n")
ns = re.search(r"^namespace\s+(\S+)", text, re.M).group(1)
name = ns.split(".")[-1]
text = re.sub(r"^import Basic$", "import Scilib.Basic", text, flags=re.M)
head, rest = text.split("\n\n", 1) if "\n\n" in text else (text, "")
text = "import ReportCmd\n" + text + f'\n\nopen ReportTool in\n#report {ns} "viz/html/{name}.html"\n'
drv = "report/build/driver.lean"
open(drv, "w", encoding="utf-8").write(text)
cmd = 'LEAN_PATH="$LEAN_PATH;report/build" lean ' + drv
r = subprocess.run(["lake", "env", "bash", "-c", cmd], capture_output=True, text=True)
print(r.stdout[-3000:], r.stderr[-3000:])
