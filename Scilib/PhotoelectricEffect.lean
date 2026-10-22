import Scilib.Basic

namespace Scilib.QuantumPhysics

/-! ## Theories & Paradigms -/

def classicalWaveTheory : Theory where
  statement := "Light is a continuous electromagnetic wave spreading energy uniformly across wavefronts; electron kinetic energy scales with wave intensity and requires energy accumulation time."
  sources := ["James Clerk Maxwell, Classical Electrodynamics"]

def atomicTriggerResonatorTheory : Theory where
  statement := "Atoms store vast internal energy reservoirs; incident light acts merely as a weak external trigger or resonance spark releasing pre-existing atomic energy, independent of light frequency."
  sources := ["J.J. Thomson Trigger Hypothesis, 1903"]

def einsteinPhotonQuantumTheory : Theory where
  statement := "Light consists of localized discrete energy quanta (photons) transferred in indivisible collisions, yielding a strict linear relation between frequency and maximum electron kinetic energy (K_max = hν - Φ)."
  sources := ["Albert Einstein, 1905"]


/-! ## Experimental Probes & Regimes -/

def vacuumPhototubeSpectroscopyProbe : Theory where
  statement := "High-vacuum photocell apparatus measuring electron emission currents and stopping potentials under monochromatic tunable light sources."
  sources := ["Lenard, Hughes, and Millikan Phototube Standards"]


/-! ## Predictions & Derived Claims -/

def intensityDependentKineticEnergyPrediction : Theory :=
  { statement := "Increasing light intensity (brightness) must proportionally increase the maximum kinetic energy and speed of emitted photoelectrons." }

def intensityIndependentThresholdPrediction : Theory :=
  { statement := "Photoelectron kinetic energy is strictly independent of light intensity; emission is governed entirely by frequency thresholds and photon energy transfer." }

def frequencyIndependentTriggerPrediction : Theory :=
  { statement := "Maximum photoelectron velocity depends on internal atomic properties and threshold triggering, lacking a universal linear slope against light frequency." }

def universalPlanckSlopePrediction : Theory :=
  { statement := "Retarding stopping potentials must vary linearly with light frequency across all clean metal surfaces, with a universal slope equal to Planck's constant divided by electron charge (h/e)." }


/-! ## Raw Experiments -/

def lenardIntensity1902 : Experiment where
  protocol := "Vary light source intensity across multiple orders of magnitude while measuring stopping potentials of emitted photoelectrons."
  observation := "Increasing light intensity increases electron current (number of electrons) but leaves stopping potential (maximum kinetic energy) completely unchanged, refuting classical wave scaling."
  sources := ["Philipp Lenard, 1902"]

def hughesRetarding1912 : Experiment where
  protocol := "Measure maximum velocity of photoelectrons emitted from various metal surfaces under diverse monochromatic ultraviolet wavelengths."
  observation := "Electron velocity depends exclusively on incident light frequency and work function, confirming independence from intensity and supporting quantum energy transfer."
  sources := ["Arthur L. Hughes, 1912"]

def millikanPrecision1916 : Experiment where
  protocol := "Construct ultra-clean high-vacuum 'machine shop in vacuo' phototubes to eliminate surface oxidation and measure stopping potentials with extreme precision across frequencies."
  observation := "Stopping potential versus frequency data points fall on an impeccably straight line whose slope measures Planck's constant h with unprecedented accuracy, vindicating Einstein's photoelectric equation."
  sources := ["Robert A. Millikan, 1916"]


/-! ## The Rigorous Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    -- Classical Wave Theory Predictions & Contradictions
    Edge.implies classicalWaveTheory intensityDependentKineticEnergyPrediction,
    Edge.contradicts intensityDependentKineticEnergyPrediction intensityIndependentThresholdPrediction,

    -- Trigger Theory Predictions & Contradictions
    Edge.implies atomicTriggerResonatorTheory frequencyIndependentTriggerPrediction,
    Edge.contradicts frequencyIndependentTriggerPrediction universalPlanckSlopePrediction,

    -- Einstein Photon Theory Predictions
    Edge.implies einsteinPhotonQuantumTheory intensityIndependentThresholdPrediction,
    Edge.implies einsteinPhotonQuantumTheory universalPlanckSlopePrediction,

    -- Probe Entailments
    Edge.entails [intensityIndependentThresholdPrediction, vacuumPhototubeSpectroscopyProbe] intensityIndependentThresholdPrediction,
    Edge.entails [universalPlanckSlopePrediction, vacuumPhototubeSpectroscopyProbe] universalPlanckSlopePrediction,

    -- Interpretations (Linking Predictions to Real Experiments)
    Edge.interprets intensityIndependentThresholdPrediction lenardIntensity1902
      "Intensity independence of kinetic energy refutes classical wave models and supports quantum threshold mechanics.",
    Edge.interprets intensityIndependentThresholdPrediction hughesRetarding1912
      "Frequency-driven photoelectron velocity measurements support quantum energy exchange.",
    Edge.interprets universalPlanckSlopePrediction millikanPrecision1916
      "High-precision linear stopping potentials validate universal Planck slope h/e and Einstein's photon equation, refuting atomic trigger hypotheses."
  ]


/-! ## Multi-Experiment Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("LenardIntensity1902", lenardIntensity1902),
    ("HughesRetarding1912", hughesRetarding1912),
    ("MillikanPrecision1916", millikanPrecision1916) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldClassicalWave : List Theory := [
  classicalWaveTheory,
  vacuumPhototubeSpectroscopyProbe
]

def worldTrigger : List Theory := [
  atomicTriggerResonatorTheory,
  vacuumPhototubeSpectroscopyProbe
]

def worldEinsteinPhoton : List Theory := [
  einsteinPhotonQuantumTheory,
  vacuumPhototubeSpectroscopyProbe
]

#eval scoreboard worldClassicalWave
#eval scoreboard worldTrigger
#eval scoreboard worldEinsteinPhoton


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.refutes worldClassicalWave lenardIntensity1902
#guard evidenceGraph.refutes worldTrigger millikanPrecision1916
#guard evidenceGraph.supports worldEinsteinPhoton lenardIntensity1902
#guard evidenceGraph.supports worldEinsteinPhoton millikanPrecision1916

end Scilib.QuantumPhysics
