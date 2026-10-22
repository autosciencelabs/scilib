import Scilib.Basic

namespace Scilib.AtomicStructure

/-! ## Theories & Models -/

def subatomicElectronTheory : Theory where
  statement := "Cathode rays consist of universal subatomic negatively charged corpuscles (electrons) emitted by all matter."
  sources := ["J.J. Thomson, 1897"]

def thomsonModel : Theory where
  statement := "Thomson Plum Pudding Model: The atom is a uniform sphere of positive charge with embedded electrons."
  sources := ["J.J. Thomson, 1904"]

def rutherfordModel : Theory where
  statement := "Rutherford Nuclear Model: Positive charge and nearly all mass are concentrated in a tiny, dense central nucleus."
  sources := ["Ernest Rutherford, 1911"]

def bohrModel : Theory where
  statement := "Bohr Quantized Model: Electrons orbit the nucleus only in specific discrete stationary states with quantized energy levels."
  sources := ["Niels Bohr, 1913"]


/-! ## Experimental Probes & Regimes -/

def vacuumCathodeTube : Theory where
  statement := "High-voltage electric field applied across a low-pressure gas discharge tube."
  sources := ["Cathode ray apparatus"]

def alphaParticleBeam : Theory where
  statement := "High-energy doubly-ionized helium atoms (alpha particles) used as scattering probes."
  sources := ["Geiger & Marsden"]

def mercuryVaporTube : Theory where
  statement := "Low-pressure mercury vapor bombarded with thermionic electrons of controlled kinetic energy."
  sources := ["Franck & Hertz setup"]

def hydrogenDischargeTube : Theory where
  statement := "Low-pressure hydrogen gas excited by electrical discharge."
  sources := ["Spectroscopy setup"]


/-! ## Derived Claims & Predictions -/

def universalChargeToMassRatio : Theory :=
  { statement := "Emitted corpuscles exhibit a constant, high charge-to-mass ratio independent of cathode material." }

def smallAngleScatteringOnly : Theory :=
  { statement := "Alpha particles pass through the atom with very small deflections." }

def largeAngleBackscattering : Theory :=
  { statement := "Alpha particles experience intense Coulomb repulsion from a massive point charge, resulting in wide deflections." }

def discreteEnergyTransfer : Theory :=
  { statement := "Electrons transfer energy to atoms in strict, discrete packets (excitation potentials), causing sudden drops in current." }

def discreteSpectralLines : Theory :=
  { statement := "Emitted light consists of discrete frequencies corresponding to quantum jumps between energy levels." }


/-! ## Raw Experiments -/

def jjThomson1897 : Experiment where
  protocol := "Measure magnetic and electrostatic deflection of cathode rays in an evacuated glass tube."
  observation := "Rays are deflected as negatively charged particles with a charge-to-mass ratio thousands of times larger than hydrogen ions."
  sources := ["J.J. Thomson, 1897"]

def geigerMarsden1909 : Experiment where
  protocol := "Bombard thin metal foils with alpha particles and count scintillations at wide angles."
  observation := "Significant fraction of alpha particles deflected past 90 degrees."
  sources := ["Geiger & Marsden, 1909"]

def franckHertz1914 : Experiment where
  protocol := "Measure current of electrons passing through mercury vapor as accelerating voltage is increased in small steps."
  observation := "Collector current drops sharply at regular 4.9 eV voltage intervals, indicating discrete energy absorption."
  sources := ["Franck & Hertz, 1914"]

def hydrogenSpectrum1885 : Experiment where
  protocol := "Analyze emitted light from excited hydrogen through a diffraction grating spectrometer."
  observation := "Sharp, discrete spectral lines (Balmer series) appear."
  sources := ["Johann Balmer, 1885"]


/-! ## The Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    Edge.implies subatomicElectronTheory universalChargeToMassRatio,
    Edge.interprets universalChargeToMassRatio jjThomson1897
      "Thomson's deflection measurements confirm universal subatomic electrons.",

    Edge.implies thomsonModel smallAngleScatteringOnly,
    Edge.contradicts smallAngleScatteringOnly largeAngleBackscattering,
    Edge.implies rutherfordModel largeAngleBackscattering,
    Edge.interprets largeAngleBackscattering geigerMarsden1909
      "Rutherford scattering explains alpha backscattering.",

    Edge.implies bohrModel discreteEnergyTransfer,
    Edge.implies bohrModel discreteSpectralLines,
    Edge.interprets discreteEnergyTransfer franckHertz1914
      "Franck-Hertz voltage drops prove atomic energy states are quantized.",
    Edge.interprets discreteSpectralLines hydrogenSpectrum1885
      "Bohr's frequency condition explains atomic emission spectra."
  ]


/-! ## Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("JJThomson1897", jjThomson1897),
    ("GeigerMarsden1909", geigerMarsden1909),
    ("FranckHertz1914", franckHertz1914),
    ("HydrogenSpectroscopy", hydrogenSpectrum1885) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldThomson : List Theory := [
  subatomicElectronTheory,
  thomsonModel,
  vacuumCathodeTube,
  alphaParticleBeam
]

def worldNuclearBohr : List Theory := [
  subatomicElectronTheory,
  rutherfordModel,
  bohrModel,
  vacuumCathodeTube,
  alphaParticleBeam,
  mercuryVaporTube,
  hydrogenDischargeTube
]

#eval scoreboard worldThomson
#eval scoreboard worldNuclearBohr

/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.supports worldThomson jjThomson1897
#guard evidenceGraph.refutes worldThomson geigerMarsden1909
#guard evidenceGraph.supports worldNuclearBohr geigerMarsden1909
#guard evidenceGraph.supports worldNuclearBohr franckHertz1914
#guard evidenceGraph.supports worldNuclearBohr hydrogenSpectrum1885

end Scilib.AtomicStructure
