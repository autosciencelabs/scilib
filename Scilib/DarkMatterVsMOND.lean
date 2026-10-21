import Basic

namespace Scilib.Astrophysics

/-! ## Theories & Paradigms -/

def modifiedNewtonianDynamicsTheory : Theory where
  statement := "Newtonian gravity breaks down at extremely low accelerations ($a < a_0$), requiring a geometric modification of inertia or gravity rather than unseen mass."
  sources := ["Mordehai Milgrom, 1983"]

def coldDarkMatterCosmologyTheory : Theory where
  statement := "General Relativity remains universally valid on all scales, but galaxies and clusters are embedded in vast halos of non-baryonic, collisionless elementary particles (Cold Dark Matter)."
  sources := ["Standard $\\Lambda$CDM Paradigm; Peebles, Blumenthal et al., 1984"]


/-! ## Experimental Probes & Regimes -/

def stellarKinematicsProbe : Theory where
  statement := "Optical and radio spectroscopic measurement of outer galactic rotation curves using 21cm hydrogen lines and stellar velocities."
  sources := ["Vera Rubin & W. Kent Ford, 1970"]

def collidingClusterProbe : Theory where
  statement := "X-ray gas imaging combined with gravitational lensing mass mapping of merging galaxy clusters."
  sources := ["Bullet Cluster Multi-Wavelength Survey, 2006"]

def cmbAnisotropyProbe : Theory where
  statement := "High-precision satellite mapping of temperature and polarization fluctuations in the Cosmic Microwave Background."
  sources := ["WMAP & Planck Collaborations"]


/-! ## Predictions & Derived Claims -/

def keplerianFalloffPrediction : Theory :=
  { statement := "Outer stellar rotation velocities must drop Keplerian-style ($v \\propto 1/\\sqrt{r}$) corresponding strictly to visible luminous mass distributions." }

def asymptoticFlatRotationPrediction : Theory :=
  { statement := "Rotation curves must flatten asymptotically at large radii, tied directly to acceleration scales or enclosed invisible mass halos." }

def gasLensMassSeparationPrediction : Theory :=
  { statement := "Collisional baryonic gas experiences ram pressure drag and separates from collisionless mass components during cluster mergers." }

def modifiedInertiaClusterFailurePrediction : Theory :=
  { statement := "Non-linear modifications of gravity should track the visible gas distribution directly during cluster collisions, failing to separate lensing mass from X-ray gas without dark matter." }

def cmbAcousticPeakRatioPrediction : Theory :=
  { statement := "Relative heights of CMB acoustic peaks require a specific ratio of cold dark matter to baryonic matter (~5:1) to shape gravitational potential wells." }


/-! ## Raw Experiments -/

def galacticRotationCurves1970 : Experiment where
  protocol := "Measure 21cm emission lines across spiral galaxies to map outer orbital velocities."
  observation := "Outer rotation curves remain flat instead of declining Keplerian-style, indicating massive gravitating discrepancies."
  sources := ["Vera Rubin & W. Kent Ford, 1970"]

def bulletCluster2006 : Experiment where
  protocol := "Analyze gravitational lensing mass maps and X-ray gas emission of colliding galaxy cluster 1E 0657-558."
  observation := "The majority of the gravitating mass (mapped via lensing) is spatially offset from the colliding X-ray emitting gas clouds, proving the existence of collisionless dark matter."
  sources := ["Douglas Clowe et al., 2006"]

def planckCmbAnisotropies : Experiment where
  protocol := "Measure precision power spectrum of temperature fluctuations across the cosmic microwave sky."
  observation := "CMB acoustic peak amplitudes require precise non-baryonic cold dark matter density parameters ($\\Omega_c h^2 \\approx 0.12$)."
  sources := ["Planck Collaboration, 2018"]


/-! ## The Rigorous Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    -- MOND Predictions & Contradictions
    Edge.implies modifiedNewtonianDynamicsTheory asymptoticFlatRotationPrediction,
    Edge.implies modifiedNewtonianDynamicsTheory modifiedInertiaClusterFailurePrediction,
    Edge.contradicts modifiedInertiaClusterFailurePrediction gasLensMassSeparationPrediction,

    -- Cold Dark Matter Predictions
    Edge.implies coldDarkMatterCosmologyTheory asymptoticFlatRotationPrediction,
    Edge.implies coldDarkMatterCosmologyTheory gasLensMassSeparationPrediction,
    Edge.implies coldDarkMatterCosmologyTheory cmbAcousticPeakRatioPrediction,

    -- Probe Entailments
    Edge.entails [asymptoticFlatRotationPrediction, stellarKinematicsProbe] asymptoticFlatRotationPrediction,
    Edge.entails [gasLensMassSeparationPrediction, collidingClusterProbe] gasLensMassSeparationPrediction,
    Edge.entails [cmbAcousticPeakRatioPrediction, cmbAnisotropyProbe] cmbAcousticPeakRatioPrediction,

    -- Interpretations
    Edge.interprets asymptoticFlatRotationPrediction galacticRotationCurves1970
      "Flat galactic rotation curves support both MOND and Dark Matter asymptotic velocity models.",
    Edge.interprets gasLensMassSeparationPrediction bulletCluster2006
      "Mass-gas offset in colliding clusters refutes pure MOND field modifications and supports particle dark matter.",
    Edge.interprets cmbAcousticPeakRatioPrediction planckCmbAnisotropies
      "CMB acoustic peak ratios validate cold dark matter density cosmological parameters."
  ]


/-! ## Multi-Experiment Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("GalacticRotation1970", galacticRotationCurves1970),
    ("BulletCluster2006", bulletCluster2006),
    ("PlanckCMB2018", planckCmbAnisotropies) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldMOND : List Theory := [
  modifiedNewtonianDynamicsTheory,
  stellarKinematicsProbe,
  collidingClusterProbe,
  cmbAnisotropyProbe
]

def worldCDM : List Theory := [
  coldDarkMatterCosmologyTheory,
  stellarKinematicsProbe,
  collidingClusterProbe,
  cmbAnisotropyProbe
]

#eval scoreboard worldMOND
#eval scoreboard worldCDM


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.refutes worldMOND bulletCluster2006
#guard evidenceGraph.supports worldCDM bulletCluster2006
#guard evidenceGraph.supports worldCDM planckCmbAnisotropies

end Scilib.Astrophysics
