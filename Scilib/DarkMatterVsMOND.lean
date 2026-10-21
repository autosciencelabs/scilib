import Basic

namespace Scilib.Astrophysics

/-! ## Theories & Paradigms -/

def standardBaryonicNewtonianDynamics : Theory where
  statement := "Standard Newtonian dynamics and GR with mass provided solely by visible baryonic matter (stars and gas)."
  sources := ["Classical Mechanics; General Relativity"]

def coldDarkMatterHypothesis : Theory where
  statement := "Galaxies and clusters are embedded in massive halos of non-baryonic, non-luminous, weakly interacting cold dark matter."
  sources := ["Vera Rubin 1970s; ΛCDM Standard Model"]

def modifiedNewtonianDynamics : Theory where
  statement := "MOND: Newton's law of inertia/gravity is modified at accelerations below a0 ≈ 1.2 × 10^-10 m/s^2 without requiring dark matter particles."
  sources := ["Mordehai Milgrom, 1983"]


/-! ## Experimental Probes & Regimes -/

def galacticRotationProbe : Theory where
  statement := "Spectroscopic and 21cm radio observations of spiral galaxy rotation curves at large radii."

def clusterCollisionLensingProbe : Theory where
  statement := "X-ray gas imaging combined with gravitational lensing maps of colliding galaxy clusters."


/-! ## Predictions & Derived Claims -/

def KeplerianKeplerianFallbackPrediction : Theory :=
  { statement := "Orbital velocities of outer gas and stars fall off as v ~ 1/√r beyond the visible baryonic disk." }

def flatRotationCurvePrediction : Theory :=
  { statement := "Orbital velocities of outer gas and stars remain constant (flat rotation curves) at large radii." }

def baryonicLensingCoincidencePrediction : Theory :=
  { statement := "Gravitational lensing mass peaks must strictly coincide with the visible baryonic gas peaks in colliding clusters." }

def separatedLensingMassPeakPrediction : Theory :=
  { statement := "Gravitational lensing mass peaks pass freely through collisions, separating cleanly from the decelerated X-ray baryonic gas." }


/-! ## Raw Experiments -/

def rubin1970RotationCurves : Experiment where
  protocol := "Measure rotational velocities of HI gas and stars in spiral galaxies out to large galactocentric radii."
  observation := "Rotation curves remain flat at large radii, contradicting the Keplerian drop-off predicted by visible baryonic mass alone."
  sources := ["Vera Rubin, Kent Ford, Albert Bosma (1970-1980)"]

def bulletCluster2006 : Experiment where
  protocol := "Map mass distribution in colliding cluster 1E 0657-558 using Chandra X-ray gas imaging and weak/strong gravitational lensing."
  observation := "Lensing mass peaks are spatially offset from the baryonic X-ray gas, proving the majority of mass is collisionless."
  sources := ["Clowe et al., 2006"]


/-! ## The Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    Edge.implies standardBaryonicNewtonianDynamics KeplerianKeplerianFallbackPrediction,
    Edge.implies standardBaryonicNewtonianDynamics baryonicLensingCoincidencePrediction,

    Edge.contradicts KeplerianKeplerianFallbackPrediction flatRotationCurvePrediction,
    Edge.contradicts baryonicLensingCoincidencePrediction separatedLensingMassPeakPrediction,

    Edge.implies coldDarkMatterHypothesis flatRotationCurvePrediction,
    Edge.implies coldDarkMatterHypothesis separatedLensingMassPeakPrediction,

    Edge.implies modifiedNewtonianDynamics flatRotationCurvePrediction,
    Edge.implies modifiedNewtonianDynamics baryonicLensingCoincidencePrediction,

    Edge.interprets flatRotationCurvePrediction rubin1970RotationCurves
      "Flat rotation curves refute purely visible Newtonian mass and support MOND / Dark Matter.",
    Edge.interprets separatedLensingMassPeakPrediction bulletCluster2006
      "Spatial separation of lensing mass from baryonic gas refutes purely modified gravity MOND and supports collisionless Dark Matter."
  ]


/-! ## Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("Rubin1970RotationCurves", rubin1970RotationCurves),
    ("BulletCluster2006", bulletCluster2006) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldStandardNewton : List Theory := [
  standardBaryonicNewtonianDynamics,
  galacticRotationProbe,
  clusterCollisionLensingProbe
]

def worldColdDarkMatter : List Theory := [
  coldDarkMatterHypothesis,
  galacticRotationProbe,
  clusterCollisionLensingProbe
]

def worldMOND : List Theory := [
  modifiedNewtonianDynamics,
  galacticRotationProbe,
  clusterCollisionLensingProbe
]

#eval scoreboard worldStandardNewton
#eval scoreboard worldColdDarkMatter
#eval scoreboard worldMOND


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.refutes worldStandardNewton rubin1970RotationCurves
#guard evidenceGraph.supports worldColdDarkMatter rubin1970RotationCurves
#guard evidenceGraph.supports worldColdDarkMatter bulletCluster2006
#guard evidenceGraph.supports worldMOND rubin1970RotationCurves
#guard evidenceGraph.refutes worldMOND bulletCluster2006

end Scilib.Astrophysics
