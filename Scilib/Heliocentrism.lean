import Scilib.ShapeOfEarth

namespace Scilib.Heliocentrism

def earthOrbitsSun : Theory :=
  { statement := "Earth orbits the Sun." }

def earthRotates : Theory :=
  { statement := "Earth rotates about its axis once per sidereal day." }

def rotatingHeliocentricModel : Theory :=
  { statement := "Earth rotates on its axis and, like the other planets, orbits the Sun." }

def stationaryPtolemaicModel : Theory :=
  { statement := "Earth is stationary at the center, and the Sun and planets orbit Earth; Venus remains between Earth and the Sun." }

def annualParallaxReading : Theory :=
  { statement := "Nearby stars show a small annual shift against more distant stars, with opposite displacement about six months apart." }

def annualAberrationReading : Theory :=
  { statement := "Stellar positions show a common annual aberration pattern." }

def foucaultPendulumReading : Theory :=
  { statement := "The swing plane of a freely moving Foucault pendulum rotates relative to the ground, with a rate that depends on latitude." }

def venusPhasesReading : Theory :=
  { statement := "Venus exhibits a full cycle of phases, with apparent size varying across the cycle." }

def venusOrbitsSun : Theory :=
  { statement := "Venus orbits the Sun." }

def distantStableStars : Theory :=
  { statement := "The background stars are sufficiently distant and stable for measured annual angular shifts to reveal the observer's changing position." }

def parallaxGeometry : Theory :=
  { statement := "An annual parallax pattern is produced by an observer changing position over the year relative to distant stars." }

def aberrationTheory : Theory :=
  { statement := "The annual stellar aberration pattern follows from the observer's changing velocity as light travels at finite speed." }

def foucaultLatitudeModel : Theory :=
  { statement := "On a rotating spherical Earth, a Foucault pendulum's swing plane appears to turn relative to the ground at a latitude-dependent rate." }

def comparativeExplanatoryCriterion : Theory :=
  { statement := "Between these stated alternatives, prefer the model that accounts for independent observations with fewer extra motions or special assumptions." }

def heliocentrismBetterThanPtolemaic : Theory :=
  { statement := "The rotating heliocentric model is better supported than the stated stationary Ptolemaic model." }

def annualParallaxExperiment : Experiment :=
  { protocol := "Measure a nearby star's position relative to more distant background stars at intervals across a year."
    observation := "A small periodic angular displacement is observed, reversing direction about six months later."
    sources := ["F. W. Bessel, Astronomische Beobachtungen auf der Königlichen Universitäts-Sternwarte zu Königsberg, 1838"] }

def annualAberrationExperiment : Experiment :=
  { protocol := "Compare the apparent positions of stars over the year using calibrated telescopic observations."
    observation := "Stars exhibit a common annual displacement pattern, distinct from their individual parallax shifts."
    sources := ["J. Bradley, Philosophical Transactions of the Royal Society, 35, 1728"] }

def foucaultPendulumExperiment : Experiment :=
  { protocol := "Release a long pendulum and track the orientation of its swing plane relative to the observatory floor."
    observation := "The swing plane turns relative to the floor; the rate varies with the pendulum's latitude."
    sources := ["L. Foucault, Comptes rendus de l'Académie des sciences, 32, 1851"] }

def venusPhasesExperiment : Experiment :=
  { protocol := "Observe Venus through a telescope over its synodic cycle and record its illuminated phase and apparent angular size."
    observation := "Venus changes from crescent through gibbous phases toward nearly full, while its apparent size changes."
    sources := ["Galileo Galilei, Sidereus Nuncius, 1610"] }

def evidenceGraph : Graph :=
  { edges := Scilib.ShapeOfEarth.evidenceGraph.edges ++
      [ Edge.interprets annualParallaxReading annualParallaxExperiment
          "The periodic displacement is interpreted as annual stellar parallax."
      , Edge.interprets annualAberrationReading annualAberrationExperiment
          "The common annual shift is interpreted as stellar aberration."
      , Edge.interprets foucaultPendulumReading foucaultPendulumExperiment
          "The changing swing-plane orientation is interpreted using the pendulum's latitude."
      , Edge.interprets venusPhasesReading venusPhasesExperiment
          "The changing illuminated fraction and apparent size are read as Venus moving around the Sun."
      , Edge.entails [annualParallaxReading, distantStableStars, parallaxGeometry]
          earthOrbitsSun
          "The annual parallax is evidence that Earth's observing position changes around the Sun."
      , Edge.entails [annualAberrationReading, aberrationTheory]
          earthOrbitsSun
          "The annual aberration independently supports Earth's changing orbital velocity."
      , Edge.entails
          [foucaultPendulumReading, Scilib.ShapeOfEarth.latitudeStarsReading,
            Scilib.ShapeOfEarth.sphericalEarth, foucaultLatitudeModel]
          earthRotates
          "The latitude-dependent pendulum behavior matches rotation on the already-established spherical Earth."
      , Edge.entails [venusPhasesReading]
          venusOrbitsSun
          "The full phase cycle places Venus on an orbit around the Sun."
      , Edge.contradicts stationaryPtolemaicModel venusPhasesReading
          "This stated arrangement keeps Venus between Earth and Sun and cannot produce its observed nearly full phases."
      , Edge.entails
          [earthOrbitsSun, earthRotates, Scilib.ShapeOfEarth.sphericalEarth]
          rotatingHeliocentricModel
          "The independently inferred orbital and axial motions form a rotating heliocentric model."
      , Edge.entails
          [rotatingHeliocentricModel, annualParallaxReading,
            annualAberrationReading, foucaultPendulumReading,
            venusPhasesReading, comparativeExplanatoryCriterion]
          heliocentrismBetterThanPtolemaic
          "The model accounts for independent evidence of annual motion, daily rotation, and Venus's phases, while the stated stationary arrangement conflicts with the phases."
      , Edge.contradicts rotatingHeliocentricModel stationaryPtolemaicModel
          "Earth cannot both orbit the Sun and remain stationary at the center."
      ] }

def orbitalEvidence : List Theory :=
  [annualParallaxReading, distantStableStars, parallaxGeometry,
    annualAberrationReading, aberrationTheory]

def rotationalEvidence : List Theory :=
  [foucaultPendulumReading, Scilib.ShapeOfEarth.latitudeStarsReading,
    Scilib.ShapeOfEarth.sphericalEarth, foucaultLatitudeModel]

def combinedEvidence : List Theory :=
  Scilib.ShapeOfEarth.combinedEvidence ++ orbitalEvidence ++ rotationalEvidence ++
    [venusPhasesReading, comparativeExplanatoryCriterion]

#guard evidenceGraph.supports Scilib.ShapeOfEarth.combinedEvidence
  Scilib.ShapeOfEarth.eratosthenesExperiment
#guard (evidenceGraph.derive Scilib.ShapeOfEarth.combinedEvidence).contains
  Scilib.ShapeOfEarth.sphericalEarth
#guard (evidenceGraph.derive orbitalEvidence).contains earthOrbitsSun
#guard (evidenceGraph.derive rotationalEvidence).contains earthRotates
#guard (evidenceGraph.derive combinedEvidence).contains rotatingHeliocentricModel
#guard (evidenceGraph.derive combinedEvidence).contains heliocentrismBetterThanPtolemaic
#guard evidenceGraph.exclusive rotatingHeliocentricModel stationaryPtolemaicModel

end Scilib.Heliocentrism
