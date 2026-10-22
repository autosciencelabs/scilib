import Scilib.Basic

namespace Scilib.Cosmology

/-! ## Theories & Paradigms -/

def staticUniverseTheory : Theory where
  statement := "The universe is static on large scales, maintained in equilibrium via a static balance of forces or cosmological constant without overall expansion."
  sources := ["Albert Einstein, 1917; Steady-State Precursors"]

def standardDeceleratingUniverseTheory : Theory where
  statement := "The universe expands from an initial Big Bang, but mutual gravitational attraction among matter components must cause cosmic expansion to steadily decelerate over time."
  sources := ["Friedmann-Lemaître Standard Model (Omega_m = 1, Omega_lambda = 0)"]

def darkEnergyLambdaCDMTheory : Theory where
  statement := "The universe is spatially flat and expanding at an accelerating rate, driven by a dominant dark energy component (positive cosmological constant Lambda) alongside cold dark matter."
  sources := ["LambdaCDM Model; Perlmutter, Riess et al., 1998; Planck Collaboration"]


/-! ## Experimental Probes & Regimes -/

def galacticSpectroscopyProbe : Theory where
  statement := "Spectroscopic measurement of stellar and galactic Doppler redshifts across local and cosmological distances."
  sources := ["Vesto Slipher & Edwin Hubble, 1920s"]

def supernovaLuminosityProbe : Theory where
  statement := "Photometric light curve and redshift calibration of distant Type Ia supernovae as standard candles."
  sources := ["Supernova Cosmology Project & High-Z Search Team"]

def largeScaleStructureProbe : Theory where
  statement := "Mapping galaxy clustering patterns and Baryon Acoustic Oscillation (BAO) standard rulers across cosmic epochs."
  sources := ["SDSS & BOSS Surveys"]

def cmbAnisotropyProbe : Theory where
  statement := "Precision mapping of acoustic peak locations and temperature power spectra in the Cosmic Microwave Background."
  sources := ["WMAP & Planck Satellite Missions"]


/-! ## Predictions & Derived Claims -/

def zeroRecessionPrediction : Theory :=
  { statement := "Galaxies should exhibit random peculiar motions without any systematic distance-proportional redshift correlation." }

def linearRecessionPrediction : Theory :=
  { statement := "Galaxies exhibit a linear velocity-distance relation (v = H_0 d), indicating a dynamic expanding space framework." }

def deceleratingBrightnessPrediction : Theory :=
  { statement := "Distant Type Ia supernovae should appear systematically brighter than linear projection because past expansion speeds were higher due to gravitational deceleration." }

def acceleratingFaintenessPrediction : Theory :=
  { statement := "Distant Type Ia supernovae must appear fainter (more distant) than decelerating models predict because recent space expansion is accelerating." }

def baoAcousticScalePrediction : Theory :=
  { statement := "Baryon Acoustic Oscillation scales require dark energy to reconcile geometry with flat spatial curvature and observed matter density." }

def cmbFlatnessAndLambdaPrediction : Theory :=
  { statement := "CMB acoustic peaks require a total energy density sum equal to critical density (Omega_total = 1.0) composed of ~70% dark energy and ~30% matter." }


/-! ## Raw Experiments -/

def hubble1929Observation : Experiment where
  protocol := "Measure distance and radial velocities of nearby galaxies via Cepheid variables and spectral shifts."
  observation := "Radial velocity is directly proportional to distance, proving the universe is expanding."
  sources := ["Edwin Hubble, 1929"]

def supernovae1998Observation : Experiment where
  protocol := "Measure light curves and redshifts of high-redshift Type Ia supernovae."
  observation := "High-redshift supernovae are systematically dimmer than predicted by matter-dominated deceleration, proving the expansion is accelerating."
  sources := ["Perlmutter et al., 1998; Riess et al., 1998"]

def bao2005Observation : Experiment where
  protocol := "Measure clustering scale of luminous galaxies across vast cosmic volumes."
  observation := "BAO correlation peaks provide a cosmic standard ruler confirming accelerated expansion history."
  sources := ["Eisenstein et al., 2005 (SDSS)"]

def planckCmb2018Observation : Experiment where
  protocol := "Measure high-resolution angular power spectrum of CMB temperature fluctuations."
  observation := "Acoustic peak positions prove spatial flatness and confirm precise dark energy parameter Omega_Lambda ~ 0.68."
  sources := ["Planck Collaboration, 2018"]


/-! ## The Rigorous Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    -- Static Universe Contradictions
    Edge.implies staticUniverseTheory zeroRecessionPrediction,
    Edge.contradicts zeroRecessionPrediction linearRecessionPrediction,

    -- Decelerating Universe Predictions & Contradictions
    Edge.implies standardDeceleratingUniverseTheory linearRecessionPrediction,
    Edge.implies standardDeceleratingUniverseTheory deceleratingBrightnessPrediction,
    Edge.contradicts deceleratingBrightnessPrediction acceleratingFaintenessPrediction,

    -- Dark Energy / LambdaCDM Predictions
    Edge.implies darkEnergyLambdaCDMTheory linearRecessionPrediction,
    Edge.implies darkEnergyLambdaCDMTheory acceleratingFaintenessPrediction,
    Edge.implies darkEnergyLambdaCDMTheory baoAcousticScalePrediction,
    Edge.implies darkEnergyLambdaCDMTheory cmbFlatnessAndLambdaPrediction,

    -- Probe Entailments
    Edge.entails [linearRecessionPrediction, galacticSpectroscopyProbe] linearRecessionPrediction,
    Edge.entails [acceleratingFaintenessPrediction, supernovaLuminosityProbe] acceleratingFaintenessPrediction,
    Edge.entails [baoAcousticScalePrediction, largeScaleStructureProbe] baoAcousticScalePrediction,
    Edge.entails [cmbFlatnessAndLambdaPrediction, cmbAnisotropyProbe] cmbFlatnessAndLambdaPrediction,

    -- Interpretations
    Edge.interprets linearRecessionPrediction hubble1929Observation
      "Linear redshift-distance relation refutes static universe models and supports dynamic expansion.",
    Edge.interprets acceleratingFaintenessPrediction supernovae1998Observation
      "Distant Type Ia supernova dimming refutes decelerating gravity models and supports dark energy acceleration.",
    Edge.interprets baoAcousticScalePrediction bao2005Observation
      "BAO standard ruler measurements validate dark energy cosmological expansion history.",
    Edge.interprets cmbFlatnessAndLambdaPrediction planckCmb2018Observation
      "CMB acoustic peaks validate spatial flatness and LambdaCDM parameters."
  ]


/-! ## Multi-Experiment Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("Hubble1929", hubble1929Observation),
    ("Supernovae1998", supernovae1998Observation),
    ("BAO2005", bao2005Observation),
    ("PlanckCMB2018", planckCmb2018Observation) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldStatic : List Theory := [
  staticUniverseTheory,
  galacticSpectroscopyProbe,
  supernovaLuminosityProbe,
  largeScaleStructureProbe,
  cmbAnisotropyProbe
]

def worldDecelerating : List Theory := [
  standardDeceleratingUniverseTheory,
  galacticSpectroscopyProbe,
  supernovaLuminosityProbe,
  largeScaleStructureProbe,
  cmbAnisotropyProbe
]

def worldLambdaCDM : List Theory := [
  darkEnergyLambdaCDMTheory,
  galacticSpectroscopyProbe,
  supernovaLuminosityProbe,
  largeScaleStructureProbe,
  cmbAnisotropyProbe
]

#eval scoreboard worldStatic
#eval scoreboard worldDecelerating
#eval scoreboard worldLambdaCDM


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.refutes worldStatic hubble1929Observation
#guard evidenceGraph.refutes worldDecelerating supernovae1998Observation
#guard evidenceGraph.supports worldLambdaCDM supernovae1998Observation
#guard evidenceGraph.supports worldLambdaCDM planckCmb2018Observation

end Scilib.Cosmology
