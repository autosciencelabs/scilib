import Lean
import Scilib.Basic

/-! `#report Ns "out.html"`: scans namespace `Ns` for `Theory`/`Experiment`/`Graph` values,
derives roles, worlds, verdicts and prose from `evidenceGraph`, and fills `report/template.html`. -/

open Lean Elab Command Scilib

namespace ReportTool

instance : Inhabited Theory := ⟨{ statement := "" }⟩
instance : Inhabited Experiment := ⟨{ protocol := "", observation := "" }⟩
instance : Inhabited Graph := ⟨{ edges := [] }⟩

unsafe def evalTheoryU (n : Name) : CoreM Theory := evalConstCheck Theory ``Scilib.Theory n
@[implemented_by evalTheoryU] opaque evalTheory (n : Name) : CoreM Theory
unsafe def evalExperimentU (n : Name) : CoreM Experiment := evalConstCheck Experiment ``Scilib.Experiment n
@[implemented_by evalExperimentU] opaque evalExperiment (n : Name) : CoreM Experiment
unsafe def evalGraphU (n : Name) : CoreM Graph := evalConstCheck Graph ``Scilib.Graph n
@[implemented_by evalGraphU] opaque evalGraph (n : Name) : CoreM Graph

/-! ### text derived from statements -/

def trimPunct (s : String) : String :=
  String.ofList (s.toList.reverse.dropWhile fun c => c == ',' || c == '.' || c == ';' || c == ' ' || c == ':').reverse

def stopWords : List String :=
  ["with", "a", "an", "the", "of", "to", "from", "and", "in", "by", "as", "for", "at", "on",
   "or", "is", "are", "that", "which", "through", "into", "between"]

/-- longest prefix of whole words that fits `n` characters, never ending on a filler word -/
def clipWords (s : String) (n : Nat) : String := Id.run do
  let ws := (s.splitOn " ").filter (· ≠ "")
  let mut out : List String := []
  let mut len := 0
  for w in ws do
    let add := w.length + (if out.isEmpty then 0 else 1)
    if len + add ≤ n then
      out := out ++ [w]
      len := len + add
    else break
  let truncated := out.length < ws.length
  while out.length > 1 && (stopWords.contains out.getLast!.toLower) do
    out := out.dropLast
  let t := trimPunct (" ".intercalate out)
  return if truncated then t ++ "…" else t

def label (s : String) : String :=
  match s.splitOn ":" with
  | pre :: _ :: _ => if pre.length ≤ 44 then pre else clipWords s 44
  | _ => clipWords s 44

def camelWords (s : String) : String := Id.run do
  let mut out := ""
  let mut prev := ' '
  for c in s.toList do
    if c.isUpper && prev.isLower then out := out ++ " "
    out := out.push c
    prev := c
  return out

/-! ### graph analysis -/

def isReading (g : Graph) (t : Theory) : Bool := g.readings.any (·.1 == t)

def rootsOf (g : Graph) : Nat → Theory → List Theory
  | 0, t => [t]
  | n + 1, t =>
    let js := g.justifications t
    if js.isEmpty then [t] else (js.flatMap fun ps => ps.flatMap (rootsOf g n)).eraseDups

def sides (g : Graph) : List Theory → Option (Theory × Theory)
  | [a, b] => if isReading g a && !isReading g b then some (b, a) else some (a, b)
  | _ => none

def supportedCount (g : Graph) (m : List Theory) (xs : List Experiment) : Nat :=
  (xs.filter (g.supports m)).length

/-- how much is lost when granting one assumption less -/
def damage (g : Graph) (xs : List Experiment) (m : List Theory) (r : Theory) : Nat :=
  let w := m.erase r
  (supportedCount g m xs - supportedCount g w xs) * 1000
    + ((g.derive m).length - (g.derive w).length)

/-- grant every assumption, then for each conflict drop the cheapest one on one side -/
def buildWorld (g : Graph) (xs : List Experiment) (roots : List Theory) (keepPrediction : Bool) :
    List Theory := Id.run do
  let mut m := roots
  for ps in g.justifications Theory.absurd do
    match sides g ps with
    | some (p, o) =>
      let d := g.derive m
      if d.contains p && d.contains o then
        let blamed := if keepPrediction then o else p
        match (rootsOf g 50 blamed).filter (m.contains ·) with
        | [] => pure ()
        | c :: cs =>
          let best := cs.foldl (fun b x => if damage g xs m x < damage g xs m b then x else b) c
          m := m.erase best
    | none => pure ()
  return m

def sameSet (a b : List Theory) : Bool := a.all b.contains && b.all a.contains

def letter (i : Nat) : String := String.singleton (Char.ofNat (65 + i))

def verdictOf (g : Graph) (m : List Theory) (x : Experiment) : String :=
  if g.refutes m x then "refuted" else if g.supports m x then "supported" else "silent"

/-! ### the report -/

def build (ns : Name) (g : Graph) (tn : List (Name × Theory)) (en : List (Name × Experiment))
    (date : String) : Json := Id.run do
  let theories := g.theories
  let readings := g.readings
  let xs : List Experiment := (readings.map (·.2)).eraseDups
  let nT := theories.length
  let tid (t : Theory) : Nat := (theories.findIdx? (· == t)).getD 0
  let xid (x : Experiment) : Nat := nT + (xs.findIdx? (· == x)).getD 0
  let short (n : Name) : String := (n.replacePrefix ns Name.anonymous).toString
  let tname (t : Theory) : String :=
    match tn.find? (·.2 == t) with | some (n, _) => short n | none => s!"node{tid t}"
  let xname (x : Experiment) : String :=
    match en.find? (·.2 == x) with | some (n, _) => short n | none => s!"experiment{xid x}"
  let roots := theories.filter fun t => (g.justifications t).isEmpty
  let tlabel (t : Theory) : String := label t.statement
  let why (p : Edge → Bool) : String :=
    match g.edges.find? p with | some e => e.why | none => ""
  let concl (t : Theory) : Edge → Bool := fun e =>
    match e.rel with | .entails _ c => c == t | _ => false
  -- nodes
  let tNodes := theories.map fun t =>
    let kind := if (g.justifications t).isEmpty && !isReading g t then "model" else "claim"
    let rel := match g.justifications t with | ps :: _ => ps.map tid | [] => []
    Json.mkObj [("id", toJson (tid t)), ("name", toJson (tname t)), ("kind", toJson kind),
      ("label", toJson (tlabel t)), ("sub", toJson (t.sources.headD "")),
      ("stmt", toJson t.statement), ("relies", toJson rel)]
  let xNodes := xs.map fun x =>
    Json.mkObj [("id", toJson (xid x)), ("name", toJson (xname x)), ("kind", toJson "experiment"),
      ("label", toJson (label x.protocol)), ("sub", toJson (x.sources.headD "")),
      ("stmt", toJson (x.protocol ++ " Observation: " ++ x.observation)),
      ("relies", toJson ([] : List Nat))]
  -- rows
  let rowInfo := xs.map fun x =>
    let r := ((readings.find? (·.2 == x)).map (·.1)).getD default
    let pred : Option Theory := (g.justifications Theory.absurd).findSome? fun ps =>
      match sides g ps with | some (p, o) => if o == r then some p else none | none => none
    (x, r, pred)
  let supportSets := rowInfo.map fun (_, r, p) =>
    rootsOf g 50 r ++ (match p with | some p => rootsOf g 50 p | none => [])
  let banner : List Theory :=
    match supportSets with
    | [] => []
    | s :: rest => if rest.isEmpty then [] else (s.eraseDups).filter fun t => rest.all (·.contains t)
  let rows := rowInfo.map fun (x, r, p) =>
    let pre := (match g.justifications r with | ps :: _ => ps | [] => []).filter (!banner.contains ·)
    Json.mkObj [("title", toJson (x.sources.headD (label x.protocol))), ("exp", toJson (xid x)),
      ("reading", toJson (tid r)),
      ("pred", toJson (match p with | some p => (tid p : Int) | none => -1)),
      ("pre", toJson (pre.map tid)), ("whyPre", toJson (why (concl r))),
      ("whyExp", toJson (why fun e => match e.rel with | .interprets i y => i == r && y == x | _ => false)),
      ("whyConflict", toJson "These two statements cannot both be true.")]
  -- worlds
  let wA := buildWorld g xs roots true
  let wB := buildWorld g xs roots false
  let ws : List (List Theory) := if sameSet wA wB then [wA] else [wA, wB]
  let worlds := ws.zipIdx.map fun (m, i) =>
    let others := ws.filter (!sameSet · m)
    let excl := m.filter fun t => others.any (!·.contains t)
    let lab := if ws.length == 1 then "Everything granted"
      else if excl.isEmpty then "Without the rival" else
        "Keeps " ++ clipWords (tlabel (excl.headD default)) 30 ++ (if excl.length > 1 then s!" and {excl.length - 1} more" else "")
    let vs := xs.map fun x => verdictOf g m x
    let cnt (v : String) := (vs.filter (· == v)).length
    let dropped := roots.filter (!m.contains ·)
    let derived := (g.derive m).filter fun t => t != Theory.absurd && !m.contains t
    let summary := s!"World {letter i} supports {cnt "supported"} of {xs.length} experiments, refutes {cnt "refuted"} and is silent on {cnt "silent"}." ++
      (if dropped.isEmpty then "" else " It does not grant: " ++ ", ".intercalate (dropped.map tlabel) ++ ".")
    Json.mkObj [("key", toJson (letter i)), ("label", toJson lab), ("members", toJson (m.map tid)),
      ("derived", toJson (derived.map tid)), ("dropped", toJson (dropped.map tid)),
      ("verdict", Json.mkObj (xs.map fun x => (toString (xid x), toJson (verdictOf g m x)))),
      ("summary", toJson summary)]
  let conflicts := (g.justifications Theory.absurd).filterMap (sides g)
  let title := camelWords ((ns.components.getLast?.map toString).getD "Evidence") ++ " as an Evidence Graph"
  let conflictText :=
    if conflicts.isEmpty then "No pair of statements in this graph contradicts another. " else
      s!"{conflicts.length} pair(s) of statements cannot both be true: " ++
      "; ".intercalate (conflicts.map fun (p, o) => s!"“{tlabel p}” against “{tlabel o}”") ++ ". "
  let wsum := " ".intercalate (worlds.map fun w => ((w.getObjValAs? String "summary").toOption.getD ""))
  let abstract := s!"This page lays out the evidence graph of {ns}: {xs.length} experiments, " ++
    s!"{theories.length - roots.length} derived claims and {roots.length} assumptions or models. " ++
    conflictText ++ "A world is a set of assumptions granted together. " ++ wsum ++
    " Hover or tap any box for its full statement."
  return Json.mkObj [("title", toJson title), ("ns", toJson ns.toString), ("date", toJson date),
    ("abstract", toJson abstract), ("nodes", toJson (tNodes ++ xNodes)),
    ("banner", toJson (banner.map tid)), ("rows", toJson rows), ("worlds", toJson worlds),
    ("conflicts", toJson (conflicts.map fun (p, o) => [tid p, tid o]))]

syntax (name := reportCmd) "#report " ident str : command

@[command_elab reportCmd] def elabReport : CommandElab := fun stx => do
  let ns := stx[1].getId
  let out := stx[2].isStrLit?.getD "report.html"
  let env ← getEnv
  let cs := env.constants.fold (init := ([] : List (Name × Expr))) fun acc n ci =>
    if ns.isPrefixOf n && !n.isInternal then (n, ci.type) :: acc else acc
  let isT (e : Expr) := e == mkConst ``Scilib.Theory
  let isX (e : Expr) := e == mkConst ``Scilib.Experiment
  let isG (e : Expr) := e == mkConst ``Scilib.Graph
  let mut tn : List (Name × Theory) := []
  let mut en : List (Name × Experiment) := []
  let mut g? : Option Graph := none
  for (n, ty) in cs.reverse do
    if isT ty then tn := tn ++ [(n, ← liftCoreM (evalTheory n))]
    else if isX ty then en := en ++ [(n, ← liftCoreM (evalExperiment n))]
    else if isG ty && n == ns ++ `evidenceGraph then g? := some (← liftCoreM (evalGraph n))
  let some g := g? | throwError "no `evidenceGraph : Graph` in namespace {ns}"
  let date ← try
      let o ← IO.Process.output { cmd := "date", args := #["+%B %d, %Y"] }
      pure (String.ofList (o.stdout.toList.filter (· != '
')))
    catch _ => pure ""
  let tpl ← IO.FS.readFile "report/template.html"
  let json := (build ns g tn en date).compress.replace "</" "<\\/"
  IO.FS.writeFile out (tpl.replace "__DATA__" json)
  logInfo m!"wrote {out}"

end ReportTool
