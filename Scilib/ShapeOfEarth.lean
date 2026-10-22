import Scilib.Basic

namespace Scilib.ShapeOfEarth

def sphericalEarth : Theory :=
  { statement := "Earth is approximately spherical." }

def flatEarth : Theory :=
  { statement := "Earth is flat." }

def parallelSunRays : Theory :=
  { statement := "Sun rays reaching Earth are effectively parallel." }

def knownMeridianDistance : Theory :=
  { statement := "The distance between Syene and Alexandria along a meridian is known." }

def sameSolarNoon : Theory :=
  { statement := "The shadow observations at Syene and Alexandria were made at the same local solar noon." }

def verticalGnomons : Theory :=
  { statement := "The gnomons at both locations were vertical." }

def eratosthenesShadowReading : Theory :=
  { statement := "At local noon the Syene gnomon cast almost no shadow, while the Alexandria gnomon cast a shadow corresponding to about 7.2 degrees." }

def meridianCurvature : Theory :=
  { statement := "Earth's surface curves along the Syene-Alexandria meridian." }

def lunarShadowReading : Theory :=
  { statement := "During a lunar eclipse, Earth's shadow on the Moon appears circular." }

def latitudeStarsReading : Theory :=
  { statement := "The altitude of the celestial pole changes with the observer's north-south location." }

def shipsHorizonReading : Theory :=
  { statement := "Distant ships disappear hull-first below the horizon." }

def eratosthenesExperiment : Experiment :=
  { protocol := "Compare vertical gnomon shadows at Syene and Alexandria at local solar noon; record their angular difference and the distance between the cities."
    observation := "Syene has almost no shadow; Alexandria's shadow angle is about 7.2 degrees, and the cities are about 5,000 stadia apart."
    sources := ["Cleomedes, On the Heavens, 1.10"] }

def lunarEclipseExperiment : Experiment :=
  { protocol := "Observe the boundary of Earth's shadow on the Moon during a lunar eclipse."
    observation := "The edge of the shadow is circular."
    sources := ["Aristotle, On the Heavens, 2.14"] }

def latitudeStarsExperiment : Experiment :=
  { protocol := "Measure the altitude of the celestial pole at locations with different north-south positions."
    observation := "The measured altitude changes with location."
    sources := ["Aristotle, On the Heavens, 2.14"] }

def shipsHorizonExperiment : Experiment :=
  { protocol := "Observe a ship sailing away over the sea horizon."
    observation := "The hull vanishes before the mast."
    sources := [] }

def evidenceGraph : Graph :=
  { edges :=
      [ Edge.interprets eratosthenesShadowReading eratosthenesExperiment
          "The different shadow angles are interpreted as a solar-angle difference."
      , Edge.entails
          [eratosthenesShadowReading, parallelSunRays, knownMeridianDistance,
            sameSolarNoon, verticalGnomons]
          meridianCurvature
          "With parallel rays and the stated measurement conditions, the shadow-angle difference indicates meridian curvature."
      , Edge.interprets lunarShadowReading lunarEclipseExperiment
          "The observed boundary is identified as Earth's shadow."
      , Edge.interprets latitudeStarsReading latitudeStarsExperiment
          "The star-altitude change is associated with the observer's location on Earth."
      , Edge.interprets shipsHorizonReading shipsHorizonExperiment
          "The ordered disappearance is treated as a geometric horizon effect."
      , Edge.entails
          [meridianCurvature, lunarShadowReading, latitudeStarsReading,
            shipsHorizonReading]
          sphericalEarth
          "Independent curvature evidence in the sky, across latitude, and at the horizon supports an approximately spherical Earth."
      , Edge.contradicts sphericalEarth flatEarth
          "A globally spherical Earth and a flat Earth are incompatible models."
      ] }

def eratosthenesAssumptions : List Theory :=
  [eratosthenesShadowReading, parallelSunRays, knownMeridianDistance,
    sameSolarNoon, verticalGnomons]

def combinedEvidence : List Theory :=
  eratosthenesAssumptions ++
    [lunarShadowReading, latitudeStarsReading, shipsHorizonReading]

#guard (evidenceGraph.derive eratosthenesAssumptions).contains meridianCurvature
#guard !(evidenceGraph.derive eratosthenesAssumptions).contains sphericalEarth
#guard (evidenceGraph.derive combinedEvidence).contains sphericalEarth
#guard evidenceGraph.exclusive sphericalEarth flatEarth

end Scilib.ShapeOfEarth
