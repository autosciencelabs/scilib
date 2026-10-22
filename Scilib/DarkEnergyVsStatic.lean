import Basic

namespace Scilib.Cosmology

/-! ## Theories & Paradigms -/

def staticOrDeceleratingUniverseTheory : Theory where
  statement := "The universe is either static or matter-dominated, meaning gravitational attraction must cause cosmic expansion to decelerate over time."
  sources := ["Einstein 1917; Classical General Relativity Standard Model"]

def darkEnergyAccelerationTheory : Theory where
  statement := "The universe contains dark energy (positive cosmological constant), generating negative pressure that causes cosmic expansion to accelerate."
  sources := ["Perlmutter, Riess et al., 1998"]


/-! ## Experimental Probes & Regimes -/

def highRedshiftSupernovaProbe : Theory where
  statement := "Photometric and spectroscopic measurements of high-redshift Type Ia supernovae as standard cosmological candles."
  sources := ["Supernova Cosmology Project & High-Z Team"]


/-! ## Predictions & Derived Claims -/

def deceleratingSupernovaeBrightnessPrediction : Theory :=
  { statement := "Distant Type Ia supernovae should appear brighter than expected in a constant expansion because gravity decelerates past expansion speed." }

def acceleratingSupernovaeFaintenessPrediction : Theory :=
  { statement := "Distant Type Ia supernovae should appear fainter (more distant) than expected in a decelerating universe due to accelerating space expansion." }


/-! ## Raw Experiments -/

def supernovae1998Observation : Experiment where
  protocol := "Measure light curves and redshifts of dozens of high-redshift Type Ia supernovae."
  observation := "High-redshift supernovae are systematically dimmer than predicted by matter-dominated deceleration, proving the expansion of the universe is accelerating."
  sources := ["Perlmutter et al., 1998; Riess et al., 1998"]


/-! ## The Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    Edge.implies staticOrDeceleratingUniverseTheory deceleratingSupernovaeBrightnessPrediction,
    Edge.contradicts deceleratingSupernovaeBrightnessPrediction acceleratingSupernovaeFaintenessPrediction,

    Edge.implies darkEnergyAccelerationTheory acceleratingSupernovaeFaintenessPrediction,
    Edge.entails [acceleratingSupernovaeFaintenessPrediction, highRedshiftSupernovaProbe] acceleratingSupernovaeFaintenessPrediction,
    Edge.interprets acceleratingSupernovaeFaintenessPrediction supernovae1998Observation
      "Distant Type Ia supernova dimming refutes decelerating gravity models and supports dark energy acceleration."
  ]


/-! ## Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("Supernovae1998", supernovae1998Observation) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldDeceleratingUniverse : List Theory := [
  staticOrDeceleratingUniverseTheory,
  highRedshiftSupernovaProbe
]

def worldDarkEnergyUniverse : List Theory := [
  darkEnergyAccelerationTheory,
  highRedshiftSupernovaProbe
]

#eval scoreboard worldDeceleratingUniverse
#eval scoreboard worldDarkEnergyUniverse


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.refutes worldDeceleratingUniverse supernovae1998Observation
#guard evidenceGraph.supports worldDarkEnergyUniverse supernovae1998Observation

end Scilib.Cosmology
