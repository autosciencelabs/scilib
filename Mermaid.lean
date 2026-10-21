import Scilib.ShapeOfEarth
import Scilib.Heliocentrism
import Scilib.Semiconductor
import Scilib.HeatCapacityOfSolids
import Scilib.SoapFilm
import Scilib.Magnus
import Scilib.Superconductivity
import Scilib.Rainbow
import Scilib.Bernoulli
import Scilib.Leidenfrost
import Scilib.Diffraction
import Scilib.Bragg
import Scilib.MendeleevSPeriodic
import Scilib.MeselsonStahl
import Scilib.OperaFasterThan
import Scilib.BaadeSTwo
import Scilib.LkMaterialsRivals
import Scilib.GevDiphotonExcess
import Scilib.PenziasWilsonHolmdel
import Scilib.JohnSnowAnd
import Scilib.ThalidomideAcrossSpecies
import Scilib.TheEtherAnd

open Scilib

namespace Mermaid

def escapeLabel (text : String) : String :=
  text.foldl (fun output character =>
    output ++
      if character == '&' then "&amp;"
      else if character == '"' then "#quot;"
      else if character == '|' then "#124;"
      else if character == '\n' || character == '\r' then " "
      else String.singleton character) ""

def indexOfTheory (theories : List Theory) (target : Theory) : Nat :=
  match theories with
  | [] => 0
  | theory :: rest => if theory == target then 0 else indexOfTheory rest target + 1

def indexOfExperiment (experiments : List Experiment) (target : Experiment) : Nat :=
  match experiments with
  | [] => 0
  | experiment :: rest =>
      if experiment == target then 0 else indexOfExperiment rest target + 1

def theoryId (theories : List Theory) (theory : Theory) : String :=
  "t" ++ toString (indexOfTheory theories theory)

def experimentId (experiments : List Experiment) (experiment : Experiment) : String :=
  "x" ++ toString (indexOfExperiment experiments experiment)

def graphExperiments (graph : Graph) : List Experiment :=
  (graph.edges.filterMap fun edge =>
    match edge.rel with
    | .interprets _ experiment => some experiment
    | .entails _ _ => none).eraseDups

def renderTheoryNodes (theories : List Theory) : List String :=
  theories.map fun theory =>
    "  " ++ theoryId theories theory ++ "[\"Theory: " ++
      escapeLabel theory.statement ++ "\"]:::theory"

def renderExperimentNodes (experiments : List Experiment) : List String :=
  experiments.map fun experiment =>
    let label :=
      "Experiment<br/>Protocol: " ++ escapeLabel experiment.protocol ++
        "<br/>Observation: " ++ escapeLabel experiment.observation
    "  " ++ experimentId experiments experiment ++ "([\"" ++ label ++ "\"]):::experiment"

def renderEdge (theories : List Theory) (experiments : List Experiment)
    (index : Nat) (edge : Edge) : List String := Id.run do
  let hyperedgeId := "h" ++ toString index
  let label := match edge.rel with
    | .entails _ _ => "entails"
    | .interprets _ _ => "interprets"
  let label := if edge.why.isEmpty then label else label ++ ": " ++ edge.why
  let declaration := "  " ++ hyperedgeId ++ "{{\"" ++ escapeLabel label ++ "\"}}:::hyperedge"
  let links := match edge.rel with
    | .entails premises conclusion =>
        premises.map (fun premise =>
          "  " ++ theoryId theories premise ++ " --> " ++ hyperedgeId) ++
        ["  " ++ hyperedgeId ++ " --> " ++ theoryId theories conclusion]
    | .interprets interpretation experiment =>
        [ "  " ++ experimentId experiments experiment ++ " --> " ++ hyperedgeId
        , "  " ++ hyperedgeId ++ " --> " ++ theoryId theories interpretation
        ]
  return declaration :: links

def renderMermaid (graph : Graph) : String := Id.run do
  let theories :=
    (graph.edges.flatMap fun edge => edge.rel.theories).eraseDups
  let experiments := graphExperiments graph
  let edgeLines := (List.range graph.edges.length).flatMap fun index =>
    match graph.edges[index]? with
    | some edge => renderEdge theories experiments index edge
    | none => []
  let lines :=
    [ "flowchart LR"
    , "  classDef theory fill:#dceeff,stroke:#315a78,stroke-width:1px"
    , "  classDef experiment fill:#e6f3e8,stroke:#39734a,stroke-width:1px"
    , "  classDef hyperedge fill:#ffe0b2,stroke:#76501e,stroke-width:2px"
    ] ++ renderTheoryNodes theories ++ renderExperimentNodes experiments ++ edgeLines
  return String.intercalate "\n" lines

def toMarkdown (title : String) (graph : Graph) : String :=
  "# " ++ title ++ "\n\n```mermaid\n" ++ renderMermaid graph ++ "\n```\n"

def generateDiagrams : IO Unit := do
structure Example where
  slug    : String
  title   : String
  modName : String                                   -- shown as "Evidence graph of ..."
  graph   : Graph
  blurb   : String := ""                             -- optional abstract override
  presets : List (String × List Theory) := []        -- optional extra buttons

def ex (slug title modName : String) (graph : Graph) : Example :=
  { slug, title, modName, graph }

/-- THE REGISTRY: one line per example. Add new examples here. -/
def examples : List Example :=
  [ ex "shape-of-earth" "Shape of Earth" "Scilib.ShapeOfEarth" Scilib.ShapeOfEarth.evidenceGraph
  , ex "heliocentrism" "Heliocentrism" "Scilib.Heliocentrism" Scilib.Heliocentrism.evidenceGraph
  , ex "semiconductor" "Semiconductor" "Scilib.Semiconductor" Scilib.Semiconductor.evidenceGraph
  , ex "heat-capacity" "Heat capacity of solids" "Scilib.HeatCapacity" Scilib.HeatCapacity.evidenceGraph
  , ex "soap-film" "Colours in soap films" "Scilib.SoapFilm" Scilib.SoapFilm.evidenceGraph
  , ex "magnus-effect" "Magnus effect" "Scilib.Magnus" Scilib.Magnus.evidenceGraph
  , ex "superconductivity" "Superconductivity" "Scilib.Superconductivity" Scilib.Superconductivity.evidenceGraph
  , ex "rainbow" "Rainbow" "Scilib.Rainbow" Scilib.Rainbow.evidenceGraph
  , ex "bernoulli" "Bernoulli's Principle" "Scilib.Bernoulli" Scilib.Bernoulli.evidenceGraph
  , ex "leidenfrost" "Leidenfrost effect" "Scilib.Leidenfrost" Scilib.Leidenfrost.evidenceGraph
  , ex "diffraction" "Light Diffraction" "Scilib.Diffraction" Scilib.Diffraction.evidenceGraph
  , ex "bragg" "Bragg's Law & X-Ray Crystallography" "Scilib.Bragg" Scilib.Bragg.evidenceGraph
  , ex "mendeleev-periodic-law" "Mendeleev's periodic law (1869-86)" "Scilib.MendeleevSPeriodic" Scilib.MendeleevSPeriodic.evidenceGraph
  , ex "meselson-stahl" "Meselson-Stahl (1958)" "Scilib.MeselsonStahl" Scilib.MeselsonStahl.evidenceGraph
  , ex "opera-neutrinos" "OPERA faster-than-light neutrinos (2011-12)" "Scilib.OperaFasterThan" Scilib.OperaFasterThan.evidenceGraph
  , ex "baade-cepheids" "Baade's two Cepheid populations (1952)" "Scilib.BaadeSTwo" Scilib.BaadeSTwo.evidenceGraph
  , ex "lk-99" "LK-99 (2023)" "Scilib.LkMaterialsRivals" Scilib.LkMaterialsRivals.evidenceGraph
  , ex "750-gev-excess" "750 GeV diphoton excess (2015-16)" "Scilib.GevDiphotonExcess" Scilib.GevDiphotonExcess.evidenceGraph
  , ex "penzias-wilson-cmb" "Penzias-Wilson, Holmdel horn antenna (1964-65)" "Scilib.PenziasWilsonHolmdel" Scilib.PenziasWilsonHolmdel.evidenceGraph
  , ex "john-snow-cholera" "John Snow and cholera, London 1854" "Scilib.JohnSnowAnd" Scilib.JohnSnowAnd.evidenceGraph
  , ex "thalidomide" "Thalidomide across species" "Scilib.ThalidomideAcrossSpecies" Scilib.ThalidomideAcrossSpecies.evidenceGraph
  , ex "ether-michelson-morley" "The ether and the speed of light (1810-1938)" "Scilib.TheEtherAnd" Scilib.TheEtherAnd.evidenceGraph
  ]

-- ADAPT: use the same fields your renderTheoryNodes / renderExperimentNodes read
def theoryName (t : Theory) : String := t.name
def theoryText (t : Theory) : String := t.statement
def experimentName (e : Experiment) : String := e.name
def experimentText (e : Experiment) : String := e.record

def graphData (ex : Example) (date : String) : Json :=
  let g := ex.graph
  let theories := ((g.edges.flatMap fun e => e.rel.theories).eraseDups).filter (· != Theory.absurd)
  let experiments := graphExperiments g
  let tid := theoryId theories
  let eid := experimentId experiments
  let ids (ts : List Theory) : Json := Json.arr (ts.map (fun t => Json.str (tid t))).toArray
  let edge (e : Edge) : Json :=
    match e.rel with
    | .entails ps c =>
        if c == Theory.absurd then
          Json.mkObj [("k", Json.str "nogood"), ("from", ids ps), ("why", Json.str e.why)]
        else
          Json.mkObj [("k", Json.str "entails"), ("from", ids ps),
                      ("to", Json.str (tid c)), ("why", Json.str e.why)]
    | .interprets i x =>
        Json.mkObj [("k", Json.str "interprets"), ("from", Json.arr #[Json.str (eid x)]),
                    ("to", Json.str (tid i)), ("why", Json.str e.why)]
  Json.mkObj
    [ ("title", Json.str ex.title), ("module", Json.str ex.modName)
    , ("date", Json.str date), ("abstract", Json.str ex.blurb)
    , ("theories", Json.arr (theories.map fun t => Json.mkObj
        [("id", Json.str (tid t)), ("name", Json.str (theoryName t)),
         ("text", Json.str (theoryText t))]).toArray)
    , ("experiments", Json.arr (experiments.map fun x => Json.mkObj
        [("id", Json.str (eid x)), ("name", Json.str (experimentName x)),
         ("text", Json.str (experimentText x))]).toArray)
    , ("edges", Json.arr (g.edges.map edge).toArray)
    , ("presets", Json.arr (ex.presets.map fun (l, ts) => Json.mkObj
        [("label", Json.str l), ("granted", ids ts)]).toArray) ]

def toHypergraphHtml (template : String) (ex : Example) (date : String) : String :=
  let json := (graphData ex date).compress.replace "</" "<\\/"
  template.replace "/*__DATA__*/null" json

def escapeHtml (s : String) : String :=
  ((s.replace "&" "&amp;").replace "<" "&lt;").replace ">" "&gt;"

def indexPage (xs : List Example) : String :=
  "<!doctype html><meta charset=\"utf-8\"><title>Scilib graphs</title>" ++
  "<h1>Scilib evidence graphs</h1><ul>" ++
  String.join (xs.map fun x =>
    s!"<li><a href=\"{x.slug}.html\">{escapeHtml x.title}</a></li>") ++ "</ul>"

def generateDiagrams : IO Unit := do
  IO.FS.createDirAll "viz"
  let template ← IO.FS.readFile "UI/hypergraph.html"
  let date ← try
      pure (← IO.Process.output { cmd := "date", args := #["+%B %-d, %Y"] }).stdout.trim
    catch _ => pure ""
  for e in examples do
    IO.FS.writeFile s!"viz/{e.slug}.md"   (toMarkdown e.title e.graph)
    IO.FS.writeFile s!"viz/{e.slug}.html" (toHypergraphHtml template e date)
  IO.FS.writeFile "viz/index.html" (indexPage examples)

end Mermaid

def main : IO Unit := Mermaid.generateDiagrams
