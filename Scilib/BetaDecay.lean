import Scilib.Basic

namespace Scilib.BetaDecay

/-! ## Theories & Models -/

def classicalTwoBodyBeta : Theory where
  statement := "Beta decay is a strict two-body decay (nucleus to daughter nucleus plus electron), governed by exact two-body kinematics."
  sources := ["Pre-1930 Nuclear Physics"]

def pauliFermiNeutrinoTheory : Theory where
  statement := "Beta decay is a three-body process where an invisible neutral spin-1/2 particle (neutrino) shares energy and momentum with the electron."
  sources := ["Wolfgang Pauli 1930; Enrico Fermi 1934"]


/-! ## Experimental Probes & Regimes -/

def magneticBetaSpectrometer : Theory where
  statement := "Calorimetric and magnetic deflection apparatus measuring the kinetic energy distribution of emitted beta particles."
  sources := ["Ellis & Wooster setup"]


/-! ## Derived Claims & Predictions -/

def monoenergeticElectronPrediction : Theory :=
  { statement := "Emitted beta electrons must exhibit a sharp, single monoenergetic energy line corresponding to the nuclear mass difference." }

def continuousElectronSpectrumPrediction : Theory :=
  { statement := "Emitted beta electrons exhibit a continuous distribution of kinetic energies ranging from zero up to the maximum decay energy." }


/-! ## Raw Experiments -/

def ellisWooster1927 : Experiment where
  protocol := "Measure total heat output and beta ray energy spectrum of radioactive beta emitters using lead absorption calorimeters and magnetic fields."
  observation := "Total heat generated matches the integral of a continuous beta energy spectrum rather than monoenergetic decay lines, proving energy is continuously distributed."
  sources := ["Charles Ellis & William Wooster, 1927"]


/-! ## The Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    Edge.implies classicalTwoBodyBeta monoenergeticElectronPrediction,
    Edge.contradicts monoenergeticElectronPrediction continuousElectronSpectrumPrediction,

    Edge.implies pauliFermiNeutrinoTheory continuousElectronSpectrumPrediction,
    Edge.entails [continuousElectronSpectrumPrediction, magneticBetaSpectrometer] continuousElectronSpectrumPrediction,
    Edge.interprets continuousElectronSpectrumPrediction ellisWooster1927
      "Pauli-Fermi neutrino theory successfully accounts for the continuous energy spectrum observed in beta decay."
  ]


/-! ## Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("EllisWooster1927", ellisWooster1927) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldClassicalTwoBody : List Theory := [
  classicalTwoBodyBeta,
  magneticBetaSpectrometer
]

def worldNeutrinoTheory : List Theory := [
  pauliFermiNeutrinoTheory,
  magneticBetaSpectrometer
]

#eval scoreboard worldClassicalTwoBody
#eval scoreboard worldNeutrinoTheory


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.refutes worldClassicalTwoBody ellisWooster1927
#guard evidenceGraph.supports worldNeutrinoTheory ellisWooster1927

end Scilib.BetaDecay
