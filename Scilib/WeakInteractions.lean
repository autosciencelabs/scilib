import Scilib.Basic

namespace Scilib.WeakInteractions

/-! ## Theories & Models -/

def parityConservationDogma : Theory where
  statement := "All physical interactions, including weak nuclear forces, are invariant under spatial inversion (parity conservation)."
  sources := ["Pre-1956 Physics Consensus"]

def maximumParityViolationTheory : Theory where
  statement := "Weak interactions maximally violate parity, distinguishing left-handed from right-handed chiral states."
  sources := ["Tsung-Dao Lee & Chen-Ning Yang, 1956"]


/-! ## Experimental Probes & Regimes -/

def polarizedCobalt60Setup : Theory where
  statement := "Cobalt-60 nuclei polarized via magnetic fields at cryogenic temperatures near absolute zero."
  sources := ["Chien-Shiung Wu setup, 1956"]


/-! ## Derived Claims & Predictions -/

def symmetricalBetaEmission : Theory :=
  { statement := "Beta decay electrons must be emitted equally in all directions relative to the nuclear spin axis." }

def asymmetricalBetaEmission : Theory :=
  { statement := "Beta decay electrons exhibit a statistically significant directional asymmetry, being preferentially emitted opposite to the nuclear spin." }


/-! ## Raw Experiments -/

def wu1956Experiment : Experiment where
  protocol := "Measure directional distribution of beta particles emitted from polarized Cobalt-60 nuclei."
  observation := "Electrons are emitted predominantly in the direction opposite to nuclear spin, proving maximum asymmetry."
  sources := ["Chien-Shiung Wu et al., 1956"]


/-! ## The Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    Edge.implies parityConservationDogma symmetricalBetaEmission,
    Edge.contradicts symmetricalBetaEmission asymmetricalBetaEmission,

    Edge.implies maximumParityViolationTheory asymmetricalBetaEmission,
    Edge.entails [asymmetricalBetaEmission, polarizedCobalt60Setup] asymmetricalBetaEmission,
    Edge.interprets asymmetricalBetaEmission wu1956Experiment
      "Wu's measurement of directional asymmetry in polarized Co-60 beta decay confirms maximum parity violation."
  ]


/-! ## Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("Wu1956", wu1956Experiment) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldParityConservation : List Theory := [
  parityConservationDogma,
  polarizedCobalt60Setup
]

def worldParityViolation : List Theory := [
  maximumParityViolationTheory,
  polarizedCobalt60Setup
]

#eval scoreboard worldParityConservation
#eval scoreboard worldParityViolation


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.refutes worldParityConservation wu1956Experiment
#guard evidenceGraph.supports worldParityViolation wu1956Experiment

end Scilib.WeakInteractions
