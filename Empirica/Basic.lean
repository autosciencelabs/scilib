import Lean

/-!
# Empirica: a semi-formal graph of theories and experiments to verify scientific reasoning

Two node types and two relations.

* `Theory`: a statement about the world (informal, optionally pointing at
  Mathlib/Physlib declarations). Interpretations of data are theories too.
* `Experiment`: a raw record (protocol + uninterpreted observation).
* `entails premises conclusion`: Horn-style implication.  Covers
  - special cases: `entails [sphere] spheroid` (restricting parameters gives a
    stronger claim, which implies the general one);
  - auxiliary hypotheses (Duhem–Quine): `entails [sphere, parallelSunRays] sunLaw`;
  - approximate or limiting correspondence, by making the shared approximate
    claim a node that both theories entail:
    `entails [newton] newtonApprox`, `entails [sr] newtonApprox`.
* Contradiction is not a primitive: it is entailment of the special theory
  `absurd`.  `Edge.contradicts a b` is `entails [a, b] absurd`, and an n-ary
  nogood is `Edge.nogood [t₁, …, tₙ]`.
* `interprets i e`: theory `i` is a reading of raw record `e`.  Logically just
  a bridge, but kept as its own constructor so the experiment/theory boundary
  is visible in the types.

Everything else (`derive`, `inconsistent`, `exclusive`, `supports`,
`refutes`, ...) is computed from the edges.  Queries take a list of *granted*
theories, so what a datum says about a hypothesis depends explicitly on which
auxiliaries you are willing to accept.

Nodes are plain Lean values: the identifier is the name, a doc comment is the
description, and edges mention the values directly.  Node identity is
structural equality.
-/

namespace Empirica

/-- A statement about the world, possibly pointing at formal declarations. -/
structure Theory where
  statement : String
  formal    : List Lean.Name := []
  sources   : List String := []
  deriving Repr, BEq

/-- The special value representing absurdity.  A set of theories is
inconsistent exactly when it derives this.  (Identity is structural, so do not
give another theory this exact statement.)  Deriving `absurd` does *not* make
everything derivable: inconsistencies stay local. -/
def Theory.absurd : Theory := { statement := "⊥ (absurdity)" }

/-- A raw recording; `observation` must stay uninterpreted. -/
structure Experiment where
  protocol    : String
  observation : String
  sources     : List String := []
  deriving Repr, BEq

inductive Rel where
  /-- All `premises` together imply `conclusion`. -/
  | entails     (premises : List Theory) (conclusion : Theory)
  /-- `interpretation` is a reading of the raw record `experiment`. -/
  | interprets  (interpretation : Theory) (experiment : Experiment)
  deriving Repr, BEq

structure Edge where
  rel    : Rel
  why    : String := ""
  formal : List Lean.Name := []
  deriving Repr, BEq

namespace Edge
def entails (premises : List Theory) (c : Theory) (why : String := "")
    (formal : List Lean.Name := []) : Edge :=
  { rel := .entails premises c, why := why, formal := formal }
/-- Single-premise `entails`, e.g. for special cases. -/
def implies (p c : Theory) (why : String := "") (formal : List Lean.Name := []) : Edge :=
  entails [p] c why formal
/-- The premises cannot all hold: they entail `absurd`. -/
def nogood (premises : List Theory) (why : String := "") (formal : List Lean.Name := []) : Edge :=
  entails premises Theory.absurd why formal
/-- `a` and `b` cannot both hold. -/
def contradicts (a b : Theory) (why : String := "") (formal : List Lean.Name := []) : Edge :=
  nogood [a, b] why formal
def interprets (i : Theory) (e : Experiment) (why : String := "")
    (formal : List Lean.Name := []) : Edge :=
  { rel := .interprets i e, why := why, formal := formal }
end Edge

def Rel.theories : Rel → List Theory
  | .entails ps c    => c :: ps
  | .interprets i _  => [i]

/-- A graph is its list of edges; nodes are whatever the edges mention. -/
structure Graph where
  edges : List Edge
  deriving Repr

namespace Graph

/-- All theories mentioned by some edge (other than `absurd`). -/
def theories (g : Graph) : List Theory :=
  (g.edges.flatMap fun e => e.rel.theories).eraseDups.filter (· != Theory.absurd)

/-- Forward chaining with fuel: each round adds at least one new theory. -/
def chase (g : Graph) : Nat → List Theory → List Theory
  | 0, s => s
  | fuel + 1, s =>
    let new := (g.edges.filterMap fun e =>
      match e.rel with
      | .entails ps c => if ps.all (s.contains ·) && !s.contains c then some c else none
      | _ => none).eraseDups
    if new.isEmpty then s else chase g fuel (s ++ new)

/-- Everything that follows from the `granted` theories (including them). -/
def derive (g : Graph) (granted : List Theory) : List Theory :=
  g.chase (g.edges.length + 1) granted.eraseDups

/-- The granted theories jointly derive `absurd`. -/
def inconsistent (g : Graph) (granted : List Theory) : Bool :=
  (g.derive granted).contains Theory.absurd

/-- `a` and `b` cannot both hold.  Contradictions with a general theory are
inherited by everything that entails it, e.g. all special cases. -/
def exclusive (g : Graph) (a b : Theory) : Bool :=
  g.inconsistent [a, b]

/-- (interpretation, experiment) pairs. -/
def readings (g : Graph) : List (Theory × Experiment) :=
  g.edges.filterMap fun e =>
    match e.rel with
    | .interprets i x => some (i, x)
    | _ => none

/-- Granting `granted`, some reading of `e` follows. -/
def supports (g : Graph) (granted : List Theory) (e : Experiment) : Bool :=
  let d := g.derive granted
  g.readings.any fun (i, x) => x == e && d.contains i

/-- `granted` is consistent, but adding some reading of `e` makes it inconsistent.
By Duhem–Quine the culprit is the conjunction of everything granted. -/
def refutes (g : Graph) (granted : List Theory) (e : Experiment) : Bool :=
  !g.inconsistent granted &&
    g.readings.any fun (i, x) => x == e && g.inconsistent (i :: granted)

/-- The premise sets that directly justify `t`: what you would have to grant.
`g.justifications Theory.absurd` lists all declared nogoods. -/
def justifications (g : Graph) (t : Theory) : List (List Theory) :=
  g.edges.filterMap fun e =>
    match e.rel with
    | .entails ps c => if c == t then some ps else none
    | _ => none

/-- Theories that are inconsistent on their own (should be empty). -/
def selfContradictory (g : Graph) : List Theory :=
  g.theories.filter fun t => g.inconsistent [t]

def wellFormed (g : Graph) : Bool :=
  g.selfContradictory.isEmpty

/-- All formal references mentioned anywhere in the graph. -/
def allRefs (g : Graph) : List Lean.Name :=
  (g.theories.flatMap (·.formal)) ++ (g.edges.flatMap (·.formal))

/-- References not found in the current environment.  Run as
`#eval show Lean.CoreM _ from myGraph.missingRefs` in a file importing Mathlib/Physlib. -/
def missingRefs (g : Graph) : Lean.CoreM (List Lean.Name) := do
  let env ← Lean.getEnv
  return g.allRefs.eraseDups.filter fun n => !env.contains n

end Graph
end Empirica
