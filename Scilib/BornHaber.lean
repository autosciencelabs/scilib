import Scilib.Basic

namespace Scilib.Chemistry

/-! ## Theories & Paradigms -/

def uncoupledElectrostaticGuess : Theory where
  statement := "Ionic crystal binding energies can be estimated via isolated electrostatic models without a unified thermochemical conservation loop."
  sources := ["Pre-1919 Classical Chemistry"]

def bornHaberCycleTheory : Theory where
  statement := "The formation of an ionic solid from elements forms a closed thermodynamic cycle (Hess's Law), enabling exact calculation of lattice energies."
  sources := ["Max Born & Fritz Haber, 1919"]


/-! ## Experimental Probes & Regimes -/

def calorimetryAndSpectroscopySetup : Theory where
  statement := "Combination of precision bomb calorimetry (enthalpy of formation) and atomic spectroscopy (ionization/dissociation energies)."
  sources := ["Standard Thermochemical Apparatus"]


/-! ## Predictions & Derived Claims -/

def inconsistentLatticeEnergyPrediction : Theory :=
  { statement := "Calculated lattice energies remain disconnected from measurable heats of formation, yielding inconsistent energetic discrepancies." }

def closedCycleEnergyConservationPrediction : Theory :=
  { statement := "The algebraic sum of enthalpy changes across sublimation, dissociation, ionization, electron attachment, and lattice formation must equal zero." }


/-! ## Raw Experiments -/

def bornHaberThermochemicalMeasurement1919 : Experiment where
  protocol := "Measure enthalpy of formation of alkali halides via calorimetry and combine with spectroscopic ionization data to calculate crystal lattice energies."
  observation := "The thermodynamic cycle closes with high precision, confirming energy conservation and yielding accurate ionic lattice energies."
  sources := ["Max Born & Fritz Haber, 1919"]


/-! ## The Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    Edge.implies uncoupledElectrostaticGuess inconsistentLatticeEnergyPrediction,
    Edge.contradicts inconsistentLatticeEnergyPrediction closedCycleEnergyConservationPrediction,

    Edge.implies bornHaberCycleTheory closedCycleEnergyConservationPrediction,
    Edge.entails [closedCycleEnergyConservationPrediction, calorimetryAndSpectroscopySetup] closedCycleEnergyConservationPrediction,
    Edge.interprets closedCycleEnergyConservationPrediction bornHaberThermochemicalMeasurement1919
      "The Born-Haber thermochemical cycle successfully closes energy balances, validating ionic lattice stability."
  ]


/-! ## Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("BornHaber1919", bornHaberThermochemicalMeasurement1919) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldUncoupledChemistry : List Theory := [
  uncoupledElectrostaticGuess,
  calorimetryAndSpectroscopySetup
]

def worldBornHaberCycle : List Theory := [
  bornHaberCycleTheory,
  calorimetryAndSpectroscopySetup
]

#eval scoreboard worldUncoupledChemistry
#eval scoreboard worldBornHaberCycle


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.refutes worldUncoupledChemistry bornHaberThermochemicalMeasurement1919
#guard evidenceGraph.supports worldBornHaberCycle bornHaberThermochemicalMeasurement1919

end Scilib.Chemistry
