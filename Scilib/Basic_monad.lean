import Lean

namespace Scilib

/-! ## Generic Logical Graph Framework -/

structure Theory where
  statement : String
  sources : List String := []
  deriving Repr, BEq

inductive Edge
  | implies (t1 t2 : Theory) (rationale : String := "") : Edge
  | contradicts (t1 t2 : Theory) (rationale : String := "") : Edge
  | interprets (t theta : Theory) (rationale : String := "") : Edge
  deriving Repr

structure Graph where
  edges : List Edge
  deriving Repr

/-- Fuel-safe derivation function guaranteeing termination -/
def Graph.derive (g : Graph) (curr : List Theory) : List Theory :=
  let rec step (known : List Theory) (fuel : Nat) : List Theory :=
    match fuel with
    | 0 => known
    | fuel + 1 =>
        let newlyDerived := g.edges.foldl (fun acc edge =>
          match edge with
          | Edge.implies t1 t2 _ =>
              if known.contains t1 && !known.contains t2 && !acc.contains t2 then
                t2 :: acc
              else acc
          | _ => acc) []
        if newlyDerived.isEmpty then
          known
        else
          step (known ++ newlyDerived) fuel
  step curr 100

def Graph.supports (g : Graph) (granted : List Theory) (theta : Theory) : Bool :=
  let derived := g.derive granted
  g.edges.any fun
    | Edge.interprets t exp _ => exp == theta && derived.contains t
    | _ => false

def Graph.refutes (g : Graph) (granted : List Theory) (theta : Theory) : Bool :=
  let derived := g.derive granted
  let contradictedTheories := g.edges.filterMap fun
    | Edge.contradicts t1 t2 _ =>
        if derived.contains t1 then some t2
        else if derived.contains t2 then some t1
        else none
    | _ => none
  g.edges.any fun
    | Edge.interprets t theta' _ =>
        theta' == theta && contradictedTheories.contains t
    | _ => false

def Graph.verdict (g : Graph) (granted : List Theory) (theta : Theory) : String :=
  if g.refutes granted theta then "refuted"
  else if g.supports granted theta then "supported"
  else "silent"


/-! ## Generic Monadic Lab Simulation Framework -/

structure Sensor (State : Type) (Reading : Type) where
  name : String
  read : State → Reading

structure Actuator (State : Type) (Command : Type) where
  name : String
  apply : Command → State → Except String State

def sense {State Reading : Type} (s : Sensor State Reading) : StateT State (Except String) Reading := do
  let st ← get
  pure (s.read st)

def actuate {State Command : Type} (a : Actuator State Command) (cmd : Command) : StateT State (Except String) Unit := do
  let st ← get
  match a.apply cmd st with
  | .ok nextState => set nextState
  | .error msg => throw msg

end Scilib
