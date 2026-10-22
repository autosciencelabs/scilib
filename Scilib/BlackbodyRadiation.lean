import Scilib.Basic
import Scilib.Formalization.BlackbodyRadiation

namespace Scilib.BlackbodyRadiation

open Scilib.Formalization.BlackbodyRadiation

/-! ## Theories & Models -/

def classicalElectrodynamics : Theory where
  formal := [``ClassicalElectrodynamics, ``classical_to_rayleighJeans]
  statement := "Maxwell's equations and the classical equipartition theorem apply to standing electromagnetic waves in a cavity."
  sources := ["Classical Physics, 19th Century"]

def rayleighJeansLaw : Theory where
  formal := [``RayleighJeansLaw, ``rayleighJeans_cutoff, ``rayleighJeansLaw_diverges]
  statement := "Rayleigh-Jeans Law: Spectral energy density is proportional to frequency squared, leading to an infinite total energy sum at high frequencies."
  sources := ["Lord Rayleigh, 1900"]

def wiensDistributionLaw : Theory where
  formal := [``WiensDistributionLaw, ``wienRadiance_pos]
  statement := "Wien's Law: Radiation emission falls off exponentially at high frequencies, successfully fitting short wavelengths but failing in the infrared."
  sources := ["Wilhelm Wien, 1896"]

def planckQuantumHypothesis : Theory where
  formal := [``PlanckQuantumHypothesis, ``quantum_step, ``quantum_planck_formula]
  statement := "Planck Quantum Hypothesis: Energy is exchanged between matter and radiation only in discrete quanta, yielding a universal distribution law."
  sources := ["Max Planck, 1900"]


/-! ## Regimes & Auxiliary Assumptions -/

def thermodynamicEquilibrium : Theory where
  formal := [``ThermodynamicEquilibrium]
  statement := "The cavity radiation is in complete thermal and thermodynamic equilibrium with the cavity walls."

def finiteTotalEnergyObservation : Theory where
  formal := [``FiniteTotalEnergyObservation]
  statement := "Measured total radiated energy density across all frequencies is strictly finite."


/-! ## Derived Claims & Predictions -/

def ultravioletDivergence : Theory :=
  {
  formal := [``UltravioletDivergence, ``ultraviolet_finite_incompatible]
  statement := "Theoretical energy density diverges to infinity as wavelength approaches zero." }

def universalBlackbodySpectrum : Theory :=
  {
  formal := [``UniversalBlackbodySpectrum, ``universal_spectrum_positive, ``planck_continuousOn,
    ``quantum_to_universal_with_fit, ``planck_density_change_of_variables]
  statement := "A single continuous formula accurately predicts spectral radiance across all infrared, visible, and ultraviolet wavelengths." }


/-! ## Raw Experiments -/

def lummerPringsheim1899 : Experiment where
  protocol := "Measure spectral energy distribution of a blackbody cavity at high temperatures across a wide wavelength range."
  observation := "Discovered systematic departures from Wien's law at longer infrared wavelengths."
  sources := ["Lummer & Pringsheim, 1899"]

def rubensKurlbaum1900 : Experiment where
  protocol := "Measure blackbody radiation specifically in the deep infrared region using improved bolometers."
  observation := "Confirmed that radiation intensity is directly proportional to temperature at long wavelengths, directly contradicting Wien's exponential drop."
  sources := ["Rubens & Kurlbaum, 1900"]


/-! ## The Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    Edge.implies classicalElectrodynamics rayleighJeansLaw,
    Edge.implies rayleighJeansLaw ultravioletDivergence,
    Edge.contradicts ultravioletDivergence finiteTotalEnergyObservation,

    Edge.interprets wiensDistributionLaw lummerPringsheim1899
      "Wien's law fits short wavelengths in Lummer-Pringsheim measurements.",

    Edge.implies planckQuantumHypothesis universalBlackbodySpectrum,
    Edge.interprets universalBlackbodySpectrum lummerPringsheim1899
      "Planck's law explains Lummer-Pringsheim data.",
    Edge.interprets universalBlackbodySpectrum rubensKurlbaum1900
      "Planck's law flawlessly matches Rubens-Kurlbaum infrared data."
  ]


/-! ## Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("LummerPringsheim1899", lummerPringsheim1899),
    ("RubensKurlbaum1900", rubensKurlbaum1900) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldClassicalRayleighJeans : List Theory := [
  classicalElectrodynamics,
  rayleighJeansLaw,
  thermodynamicEquilibrium,
  finiteTotalEnergyObservation
]

def worldPlanckQuantum : List Theory := [
  planckQuantumHypothesis,
  thermodynamicEquilibrium,
  finiteTotalEnergyObservation
]

#eval scoreboard worldClassicalRayleighJeans
#eval scoreboard worldPlanckQuantum


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.supports worldPlanckQuantum rubensKurlbaum1900
#guard evidenceGraph.supports worldPlanckQuantum lummerPringsheim1899

end Scilib.BlackbodyRadiation
