import Scilib.ShapeOfEarth
import Scilib.Heliocentrism
import Scilib.Semiconductor
import Scilib.HeatCapacityOfSolids
import Scilib.SoapFilm
import Scilib.Magnus
import Scilib.Superconductors

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
  IO.FS.createDirAll "viz"
  IO.FS.writeFile "viz/shape-of-earth.md"
    (toMarkdown "Shape of Earth" Scilib.ShapeOfEarth.evidenceGraph)
  IO.FS.writeFile "viz/heliocentrism.md"
    (toMarkdown "Heliocentrism" Scilib.Heliocentrism.evidenceGraph)
  IO.FS.writeFile "viz/semiconductor.md"
    (toMarkdown "Semiconductor" Scilib.Semiconductor.evidenceGraph)
  IO.FS.writeFile "viz/heat-capacity.md"
    (toMarkdown "Heat capacity of solids" Scilib.HeatCapacity.evidenceGraph)
  IO.FS.writeFile "viz/soap-film.md"
    (toMarkdown "Colours in soap films" Scilib.SoapFilm.evidenceGraph)
  IO.FS.writeFile "viz/magnus-effect.md"
    (toMarkdown "Magnus effect" Scilib.Magnus.evidenceGraph)
  IO.FS.writeFile "viz/superconductors.md"
    (toMarkdown "Superconductors" Scilib.Superconductors.evidenceGraph)

end Mermaid

def main : IO Unit := Mermaid.generateDiagrams
