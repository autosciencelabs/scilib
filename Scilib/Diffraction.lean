import Scilib.Basic

namespace Scilib.Diffraction

open Scilib

/-! ## Theories & Models -/

def waveTheoryOfLight : Theory := {
  statement := "Light propagates as transverse waves capable of undergoing mutual interference and bending around obstacles."
  sources := ["Thomas Young, 1801; Augustin-Jean Fresnel, 1818"]
}

def huygensFresnelPrinciple : Theory := {
  statement := "Every point on a wavefront acts as a source of secondary spherical wavelets, and the new wavefront is the envelope of these wavelets."
  sources := ["Christiaan Huygens & Augustin-Jean Fresnel"]
}

def fraunhoferApproximation : Theory := {
  statement := "When both the light source and viewing screen are effectively at infinity relative to the aperture size, diffracted wavefronts can be treated as parallel (plane waves)."
  sources := ["Fraunhofer Diffraction Theory"]
}

def geometricalOptics : Theory := {
  statement := "Light travels strictly in rectilinear rays, ignoring wave interference and diffraction around sharp edges."
  sources := ["Classical Ray Optics"]
}


/-! ## Experimental Probes & Regimes -/

def monochromaticLaserBeam : Theory := {
  statement := "Coherent light source characterized by a single precise wavelength."
  sources := ["Laser apparatus"]
}

def singleSlitAperture : Theory := {
  statement := "A narrow rectangular opening whose width is comparable to the wavelength of incident light."
  sources := ["Slit apparatus"]
}

def sharpKnifeEdge : Theory := {
  statement := "An opaque screen featuring an abrupt rectilinear edge placed across a light beam."
  sources := ["Knife-edge obstacle"]
}


/-! ## Derived Claims & Predictions -/

def singleSlitInterferencePattern : Theory := {
  statement := "A single slit produces a central bright maximum flanked by alternating dark minima and secondary maxima."
}

def geometricalShadowPrediction : Theory := {
  statement := "Light passing a sharp edge projects a perfectly abrupt boundary between complete illumination and complete shadow."
}

def diffractionFringeObservation : Theory := {
  statement := "Light passing a sharp edge spills into the shadow region, forming alternating bright and dark interference fringes."
}


/-! ## Raw Experiments -/

def laserSingleSlit1960 : Experiment := {
  protocol := "Shine a coherent laser through a narrow single slit onto a distant screen and record the intensity profile."
  observation := "An unmistakable pattern of bright and dark diffraction fringes appears, perfectly matching wave predictions."
  sources := ["Laser Single-Slit Experiment"]
}

def fresnelKnifeEdge1818 : Experiment := {
  protocol := "Examine the shadow cast by a sharp straight edge illuminated by a point source of light."
  observation := "Fringes of light appear inside the geometrical shadow boundary, directly contradicting rectilinear propagation."
  sources := ["Augustin-Jean Fresnel, 1818"]
}


/-! ## The Evidence Graph -/

def evidenceGraph : Graph := {
  edges := [
    Edge.implies waveTheoryOfLight singleSlitInterferencePattern "Wave theory predicts single slit fringes",
    Edge.interprets singleSlitInterferencePattern laserSingleSlit1960 "Laser diffraction profile confirmation",

    Edge.implies geometricalOptics geometricalShadowPrediction "Rectilinear ray propagation predicts sharp shadow",
    Edge.contradicts geometricalShadowPrediction diffractionFringeObservation "Sharp shadow contradicts fringe spillover",
    Edge.implies waveTheoryOfLight diffractionFringeObservation "Wave theory accounts for fringe spillover",
    Edge.interprets diffractionFringeObservation fresnelKnifeEdge1818 "Knife-edge fringe observation"
  ]
}


/-! ## Analysis & Scoreboards -/

def experiments : List (String × Experiment) := [
  ("LaserSingleSlit1960", laserSingleSlit1960),
  ("FresnelKnifeEdge1818", fresnelKnifeEdge1818)
]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldGeometricalOptics : List Theory := [
  geometricalOptics,
  singleSlitAperture,
  sharpKnifeEdge
]

def worldWaveOptics : List Theory := [
  waveTheoryOfLight,
  huygensFresnelPrinciple,
  fraunhoferApproximation,
  monochromaticLaserBeam,
  singleSlitAperture,
  sharpKnifeEdge
]

#eval scoreboard worldGeometricalOptics
#eval scoreboard worldWaveOptics


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.supports worldWaveOptics laserSingleSlit1960
#guard evidenceGraph.supports worldWaveOptics fresnelKnifeEdge1818
#guard evidenceGraph.refutes worldGeometricalOptics fresnelKnifeEdge1818

end Scilib.Diffraction
