import Basic

namespace Scilib.QuantumPhysics

/-! ## Theories & Paradigms -/

def classicalOrbitalOnlyModel : Theory where
  statement := "Electrons possess only orbital angular momentum around the nucleus; magnetic moments and angular momenta obey classical electrodynamics and integer quantum numbers."
  sources := ["Bohr-Sommerfeld Classical-Quantum Transition Model"]

def electronIntrinsicSpinHypothesis : Theory where
  statement := "Electrons possess an intrinsic, permanent quantum angular momentum (spin) s = 1/2 with a gyromagnetic ratio anomaly g ≈ 2."
  sources := ["George Uhlenbeck & Samuel Goudsmit, 1925; Paul Dirac, 1928"]


/-! ## Experimental Probes & Regimes -/

def molecularBeamSpectroscopyProbe : Theory where
  statement := "Collimated neutral atomic/molecular beams passing through intense inhomogeneous magnetic field gradients."
  sources := ["Stern-Gerlach Apparatus Standards"]

def fineStructureSpectroscopyProbe : Theory where
  statement := "High-resolution optical emission and absorption spectroscopy of alkali metal vapors."
  sources := ["Atomic Emission Spectrometry"]

def gyromagneticInertialProbe : Theory where
  statement := "Measurement of mechanical rotation induced by magnetization changes in ferromagnetic cylinders (Einstein-de Haas effect)."
  sources := ["Macroscopic Angular Momentum Balance"]


/-! ## Predictions & Derived Claims -/

def continuousOrSingleBeamDeflectionPrediction : Theory :=
  { statement := "Atomic beams in magnetic gradients should smear continuously due to random orientation, or split into odd integer numbers of beams (2l+1)." }

def discreteTwoValuedSplittingPrediction : Theory :=
  { statement := "Atomic beams must split into exactly two discrete spatial components (spin-up and spin-down) regardless of orbital angular momentum." }

def orbitalGyromagneticRatioPrediction : Theory :=
  { statement := "The gyromagnetic ratio factor should be g = 1, matching classical circulating charge orbits." }

def spinGyromagneticRatioAnomalyPrediction : Theory :=
  { statement := "The gyromagnetic ratio factor for electron spin must be g ≈ 2, doubling the magnetic splitting expected from orbital motion alone." }


/-! ## Raw Experiments -/

def sternGerlach1922 : Experiment where
  protocol := "Pass a thermal beam of silver atoms through an inhomogeneous magnetic field and record deposition profile on a glass plate."
  observation := "The silver beam splits cleanly into two distinct, discrete traces, proving spatial quantization and two-valued angular momentum."
  sources := ["Otto Stern & Walther Gerlach, 1922"]

def einsteinDeHaas1915 : Experiment where
  protocol := "Suspend an iron cylinder on a torsion fiber and rapidly reverse its magnetization, measuring the resulting mechanical twist."
  observation := "The measured angular momentum imparted to the cylinder reveals a gyromagnetic ratio corresponding to g ≈ 2, proving magnetic moments arise from electron spin rather than orbital currents alone."
  sources := ["Albert Einstein & Wander de Haas, 1915"]

def alkaliFineStructure1925 : Experiment where
  protocol := "Measure high-precision doublet frequency splitting in sodium emission spectra."
  observation := "Sodium D-lines exhibit precise fine-structure doublet splittings accounted for by half-integer spin-orbit coupling."
  sources := ["Spectroscopic Data / Uhlenbeck & Goudsmit, 1925"]


/-! ## The Rigorous Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    -- Classical Orbital Model Predictions & Contradictions
    Edge.implies classicalOrbitalOnlyModel continuousOrSingleBeamDeflectionPrediction,
    Edge.implies classicalOrbitalOnlyModel orbitalGyromagneticRatioPrediction,
    Edge.contradicts continuousOrSingleBeamDeflectionPrediction discreteTwoValuedSplittingPrediction,
    Edge.contradicts orbitalGyromagneticRatioPrediction spinGyromagneticRatioAnomalyPrediction,

    -- Intrinsic Spin Model Predictions
    Edge.implies electronIntrinsicSpinHypothesis discreteTwoValuedSplittingPrediction,
    Edge.implies electronIntrinsicSpinHypothesis spinGyromagneticRatioAnomalyPrediction,

    -- Probe Entailments
    Edge.entails [discreteTwoValuedSplittingPrediction, molecularBeamSpectroscopyProbe] discreteTwoValuedSplittingPrediction,
    Edge.entails [spinGyromagneticRatioAnomalyPrediction, gyromagneticInertialProbe] spinGyromagneticRatioAnomalyPrediction,
    Edge.entails [discreteTwoValuedSplittingPrediction, fineStructureSpectroscopyProbe] discreteTwoValuedSplittingPrediction,

    -- Interpretations (Linking Predictions to Real Experiments)
    Edge.interprets discreteTwoValuedSplittingPrediction sternGerlach1922
      "Two-fold beam splitting refutes classical smearing/odd-integer models and supports quantized intrinsic angular momentum.",
    Edge.interprets spinGyromagneticRatioAnomalyPrediction einsteinDeHaas1915
      "Gyromagnetic ratio g ≈ 2 refutes classical g=1 orbital ratios and supports electron spin.",
    Edge.interprets discreteTwoValuedSplittingPrediction alkaliFineStructure1925
      "Alkali spectral doublets validate half-integer spin sub-levels."
  ]


/-! ## Multi-Experiment Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("SternGerlach1922", sternGerlach1922),
    ("EinsteinDeHaas1915", einsteinDeHaas1915),
    ("AlkaliFineStructure1925", alkaliFineStructure1925) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldClassicalOrbital : List Theory := [
  classicalOrbitalOnlyModel,
  molecularBeamSpectroscopyProbe,
  gyromagneticInertialProbe,
  fineStructureSpectroscopyProbe
]

def worldElectronSpin : List Theory := [
  electronIntrinsicSpinHypothesis,
  molecularBeamSpectroscopyProbe,
  gyromagneticInertialProbe,
  fineStructureSpectroscopyProbe
]

#eval scoreboard worldClassicalOrbital
#eval scoreboard worldElectronSpin


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.refutes worldClassicalOrbital sternGerlach1922
#guard evidenceGraph.refutes worldClassicalOrbital einsteinDeHaas1915
#guard evidenceGraph.refutes worldClassicalOrbital alkaliFineStructure1925

#guard evidenceGraph.supports worldElectronSpin sternGerlach1922
#guard evidenceGraph.supports worldElectronSpin einsteinDeHaas1915
#guard evidenceGraph.supports worldElectronSpin alkaliFineStructure1925

end Scilib.QuantumPhysics
