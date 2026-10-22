import Scilib.Basic
import Scilib.Formalization.Bragg

namespace Scilib.Bragg

open Scilib Scilib.Formalization.Bragg

/-! ## Theories & Models -/

def crystalLattice : Theory := {
  formal := [``CrystalLattice, ``sitePosition_translate]
  statement := "A crystal consists of a periodic array of atoms or ions forming planes capable of scattering radiation."
  sources := ["Crystallography principles"]
}

def braggsLaw : Theory := {
  formal := [``BraggsLaw, ``constructive_of_bragg, ``braggsLaw_proof]
  statement := "Constructive interference of X-rays scattered from adjacent crystal planes occurs when n times lambda equals 2 times d times sin(theta)."
  sources := ["William Henry Bragg and William Lawrence Bragg, 1913"]
}

def waveNatureOfXRays : Theory := {
  formal := [``WaveNatureOfXRays, ``monochromatic_satisfies_maxwell]
  statement := "X-rays propagate as electromagnetic waves with wavelengths comparable to atomic spacing in crystals."
  sources := ["Max von Laue, 1912"]
}

def randomAmorphousStructure : Theory := {
  formal := [``RandomAmorphousStructure]
  statement := "The target material lacks long-range periodic atomic order."
}


/-! ## Experimental Probes & Regimes -/

def monochromaticXRayBeam : Theory := {
  formal := [``MonochromaticXRayBeam]
  statement := "A collimated beam of X-rays possessing a single well-defined wavelength."
  sources := ["X-ray tube apparatus"]
}

def singleCrystalTarget : Theory := {
  formal := [``SingleCrystalTarget]
  statement := "A high-purity single crystal mounted on a goniometer for precise angular rotation."
  sources := ["Crystalline sample"]
}


/-! ## Derived Claims & Predictions -/

def braggPeakPrediction : Theory := {
  formal := [``BraggPeakPrediction, ``stackIntensity_at_bragg, ``bragg_is_global_max]
  statement := "Monochromatic X-rays incident on a crystal produce sharp reflection peaks at specific angles satisfying Bragg's law."
}

def amorphousDiffuseScattering : Theory := {
  formal := [``AmorphousDiffuseScattering]
  statement := "Amorphous materials yield broad diffuse scattering halos rather than sharp Bragg diffraction peaks."
}


/-! ## Raw Experiments -/

def braggSpectrometer1913 : Experiment := {
  protocol := "Direct a monochromatic X-ray beam onto a cleavage face of a rock salt crystal and measure ionization current versus glancing angle."
  observation := "Sharp reflection peaks appear at precise angles corresponding exactly to the Bragg condition."
  sources := ["W.H. & W.L. Bragg, 1913"]
}


/-! ## The Evidence Graph -/

def evidenceGraph : Graph := {
  edges := [
    Edge.implies crystalLattice braggPeakPrediction "Periodic lattice enables coherent reinforcement",
    Edge.implies waveNatureOfXRays braggPeakPrediction "Wave interference condition required for Bragg peaks",
    Edge.implies braggsLaw braggPeakPrediction "Bragg equation determines peak positions",
    Edge.interprets braggPeakPrediction braggSpectrometer1913 "X-ray spectrometer peaks confirm Bragg condition"
  ]
}


/-! ## Analysis & Scoreboards -/

def experiments : List (String × Experiment) := [
  ("BraggSpectrometer1913", braggSpectrometer1913)
]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldBraggCrystal : List Theory := [
  crystalLattice,
  braggsLaw,
  waveNatureOfXRays,
  monochromaticXRayBeam,
  singleCrystalTarget
]

def worldAmorphous : List Theory := [
  randomAmorphousStructure,
  monochromaticXRayBeam
]

#eval scoreboard worldBraggCrystal
#eval scoreboard worldAmorphous


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.supports worldBraggCrystal braggSpectrometer1913

end Scilib.Bragg
