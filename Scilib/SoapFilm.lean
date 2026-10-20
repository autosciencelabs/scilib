import Scilib.Basic

/-!
# Colours in soap films: one project, many connected laws

A thin transparent film shows colours that no pigment explains.  This file
shows that a *single* small set of laws (wave superposition, refraction,
a half-cycle phase shift on reflection, energy conservation) explains
seven different observations:

1. colour depends on film thickness            (Hooke 1665, Newton 1704)
2. brightness is periodic in thickness         (Newton 1704, single-colour light)
3. the thinnest film looks black               (Hooke 1665, Newton 1704)
4. colours shift with viewing angle            (Newton 1704)
5. Newton's rings have a dark centre           (Newton 1704, Young 1801-1807)
6. transmitted colours are complementary       (Newton 1704)
7. Lloyd's mirror has a dark edge fringe       (Lloyd 1834)

Two rival theories (pigment, and "reflection never shifts phase") are
refuted by the data.
-/

namespace Scilib.SoapFilm

/-! ## Laws and set-ups that are granted -/

def waveSuperposition : Theory :=
  { statement := "Light is a wave: coherent waves of the same frequency add in amplitude, so a half-cycle phase difference cancels them and a whole-cycle difference reinforces them."
    sources := ["T. Young, Philosophical Transactions of the Royal Society, 92, 1802"] }

def snellLaw : Theory :=
  { statement := "Refraction at an interface obeys n₁ sin θ₁ = n₂ sin θ₂."
    sources := ["R. Descartes, La Dioptrique, 1637"] }

def wavelengthInMedium : Theory :=
  { statement := "In a medium of refractive index n the wavelength is λ₀ / n, where λ₀ is the vacuum wavelength." }

def reflectionPhaseRule : Theory :=
  { statement := "Reflection from a medium of higher refractive index shifts the phase by half a cycle; reflection from a medium of lower index does not."
    sources := ["G. G. Stokes, Cambridge and Dublin Mathematical Journal, 1849",
                "A. Fresnel, Annales de chimie et de physique, 1823"] }

def energyConservation : Theory :=
  { statement := "For a non-absorbing film, reflected plus transmitted intensity equals incident intensity at each wavelength." }

def whiteLightIsMixture : Theory :=
  { statement := "White light is a mixture of wavelengths, and each wavelength interferes independently of the others."
    sources := ["I. Newton, Philosophical Transactions of the Royal Society, 80, 1672"] }

def filmGeometry : Theory :=
  { statement := "A film of local thickness t has two nearly parallel interfaces; light reflects once from each, and the two reflected rays recombine." }

def soapFilmSetup : Theory :=
  { statement := "A soap film (n ≈ 1.33) is bounded on both sides by air (n ≈ 1.00)." }

def airGapSetup : Theory :=
  { statement := "Newton's rings set-up: a thin air gap (n ≈ 1.00) between a glass lens and a flat glass plate (n ≈ 1.5), gap thickness zero at the contact point." }

def lloydSetup : Theory :=
  { statement := "Lloyd's mirror: a slit source illuminates a screen directly and by grazing reflection off a flat mirror; the two path lengths are equal at the mirror's edge." }

def drainageWedge : Theory :=
  { statement := "Gravity drains a vertical soap film, so its thickness grows from top to bottom." }

def topIsThin : Theory :=
  { statement := "Just before it bursts, the top of the film is much thinner than a visible wavelength (t ≪ λ)."
    sources := ["R. Hooke, Micrographia, 1665", "I. Newton, Opticks, 1704"] }

def absorptionIsMonotonic : Theory :=
  { statement := "A uniform absorbing pigment dims light steadily as the path through it grows (Beer–Lambert), never periodically." }

/-! ## Derived laws -/

def opticalPathDifference : Theory :=
  { statement := "The ray reflected from the back interface travels an extra optical path 2 n t cos θₜ compared with the ray reflected from the front." }

def relativePhaseSoap : Theory :=
  { statement := "For a soap film in air, only the front reflection (air → film) carries a half-cycle shift, so the two reflected rays differ by an extra half cycle." }

def relativePhaseAirGap : Theory :=
  { statement := "For an air gap between glass, only the back reflection (air → glass) carries a half-cycle shift, so the two reflected rays differ by an extra half cycle." }

def thinFilmCondition : Theory :=
  { statement := "A soap film in air reflects most strongly when 2 n t cos θₜ = (m + ½) λ₀ and least when 2 n t cos θₜ = m λ₀, for integer m." }

def airGapCondition : Theory :=
  { statement := "An air gap between glass reflects least when 2 t = m λ (so the centre, t = 0, is dark) and most when 2 t = (m + ½) λ." }

def unifiedThinFilmTheory : Theory :=
  { statement := "Superposition plus one half-cycle reflection rule explains soap-film colours, the black film, Newton's rings and Lloyd's mirror with no extra assumptions." }

/-! ## Rival theories -/

def pigmentModel : Theory :=
  { statement := "Soap-film colours come from a coloured pigment in the soap solution that absorbs selected wavelengths." }

def noPhaseShiftModel : Theory :=
  { statement := "Reflection never changes phase; only the path difference matters." }

/-! ## Readings of the raw records -/

def colourVsThicknessReading : Theory :=
  { statement := "Reflected colour depends on local film thickness and repeats in a fixed sequence as thickness increases." }

def periodicBrightnessReading : Theory :=
  { statement := "In single-wavelength light, reflected brightness alternates periodically with film thickness." }

def blackFilmReading : Theory :=
  { statement := "The thinnest part of the film reflects almost no light." }

def obliqueShiftReading : Theory :=
  { statement := "As the viewing angle from the normal grows, the colour of a given film region shifts toward shorter wavelengths." }

def darkCentreReading : Theory :=
  { statement := "Where the air gap shrinks to zero thickness, reflection is nearly absent; bright and dark rings alternate around it." }

def complementaryReading : Theory :=
  { statement := "At each spot, the colour seen in transmitted light is complementary to the colour seen in reflected light." }

def lloydDarkEdgeReading : Theory :=
  { statement := "The fringe at the edge of the mirror, where direct and reflected paths are equal, is dark." }

/-! ## Raw experiments -/

def whiteLightFilmExperiment : Experiment :=
  { protocol := "Hold a vertical soap film in a frame, illuminate it with white light and watch the reflected light as the film drains."
    observation := "Coloured horizontal bands appear; the colour sequence repeats down the film and the bands slide downward over time."
    sources := ["R. Hooke, Micrographia, 1665", "I. Newton, Opticks, Book II, 1704"] }

def monochromaticFilmExperiment : Experiment :=
  { protocol := "Repeat the vertical film observation using a sodium lamp (λ₀ ≈ 589 nm) instead of white light."
    observation := "Alternating bright and dark horizontal bands, with no other colours."
    sources := ["I. Newton, Opticks, Book II, 1704"] }

def blackFilmExperiment : Experiment :=
  { protocol := "Watch the uppermost part of a vertical soap film in white light until the film bursts."
    observation := "The colours at the top give way to a region that appears black, shortly before rupture."
    sources := ["R. Hooke, Micrographia, 1665", "I. Newton, Opticks, 1704"] }

def viewingAngleExperiment : Experiment :=
  { protocol := "Fix a film region and compare its reflected colour as the viewing direction is tilted from the normal toward grazing."
    observation := "The colour of that region changes toward the blue end as the tilt increases."
    sources := ["I. Newton, Opticks, Book II, 1704"] }

def newtonRingsExperiment : Experiment :=
  { protocol := "Press a plano-convex lens onto a flat glass plate and view the contact region in reflected monochromatic light."
    observation := "Concentric bright and dark rings surround a dark central spot."
    sources := ["I. Newton, Opticks, Book II, 1704", "T. Young, A Course of Lectures on Natural Philosophy, 1807"] }

def transmissionExperiment : Experiment :=
  { protocol := "View the same film region in reflected and in transmitted white light."
    observation := "The transmitted colour is the complement of the reflected colour at every spot."
    sources := ["I. Newton, Opticks, Book II, 1704"] }

def lloydMirrorExperiment : Experiment :=
  { protocol := "Illuminate a screen from a narrow slit directly and via grazing reflection from a flat mirror whose edge meets the screen."
    observation := "Interference fringes appear on the screen, with a dark fringe at the mirror's edge."
    sources := ["H. Lloyd, Transactions of the Royal Irish Academy, 17, 1837"] }

/-! ## The evidence graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- readings of raw records
        Edge.interprets colourVsThicknessReading whiteLightFilmExperiment
          "Colour varies down the film, where thickness varies, so colour is read as a function of thickness."
      , Edge.interprets periodicBrightnessReading monochromaticFilmExperiment
          "With one wavelength only brightness can vary, and it does so periodically."
      , Edge.interprets blackFilmReading blackFilmExperiment
          "The darkest region is the thinnest one, just before rupture."
      , Edge.interprets obliqueShiftReading viewingAngleExperiment
          "Same film region, different viewing angle: the colour change is read as angle dependence."
      , Edge.interprets darkCentreReading newtonRingsExperiment
          "The central spot is where the gap thickness is zero."
      , Edge.interprets complementaryReading transmissionExperiment
          "Reflected and transmitted colours are compared at the same spots."
      , Edge.interprets lloydDarkEdgeReading lloydMirrorExperiment
          "The screen position with equal path lengths is the mirror's edge."

        -- derived laws
      , Edge.entails [snellLaw, filmGeometry] opticalPathDifference
          "Geometry of the two rays, with the refraction angle from Snell's law, gives 2 n t cos θₜ."
      , Edge.entails [reflectionPhaseRule, soapFilmSetup] relativePhaseSoap
          "Air → film is a higher-index reflection, film → air is a lower-index one."
      , Edge.entails [reflectionPhaseRule, airGapSetup] relativePhaseAirGap
          "Glass → air is a lower-index reflection, air → glass is a higher-index one."
      , Edge.entails
          [waveSuperposition, opticalPathDifference, wavelengthInMedium, relativePhaseSoap]
          thinFilmCondition
          "Total phase difference = path difference in wavelengths plus half a cycle; reinforce or cancel by superposition."
      , Edge.entails
          [waveSuperposition, opticalPathDifference, relativePhaseAirGap]
          airGapCondition
          "Same argument with n = 1 and the half-cycle shift on the back reflection."

        -- the laws predict the readings
      , Edge.entails [thinFilmCondition, whiteLightIsMixture, drainageWedge] colourVsThicknessReading
          "Each thickness reinforces some wavelengths and cancels others; drainage makes t vary with height, so the colours form horizontal bands."
      , Edge.entails [thinFilmCondition, drainageWedge] periodicBrightnessReading
          "Brightness repeats each time t changes by λ₀ / (2n cos θₜ); the drainage wedge turns this into bands down the film."
      , Edge.entails [thinFilmCondition, topIsThin] blackFilmReading
          "As t → 0 the path difference vanishes, leaving only the half-cycle shift: total cancellation."
      , Edge.entails [thinFilmCondition] obliqueShiftReading
          "Larger angle means smaller cos θₜ, so the condition is met at a shorter wavelength."
      , Edge.entails [airGapCondition] darkCentreReading
          "At t = 0 the condition for minimum reflection holds for every wavelength."
      , Edge.entails [thinFilmCondition, energyConservation] complementaryReading
          "Wavelengths missing from reflection must appear in transmission."
      , Edge.entails [waveSuperposition, reflectionPhaseRule, lloydSetup] lloydDarkEdgeReading
          "Equal paths, but the reflected ray gets a half-cycle shift, so it cancels the direct ray."

        -- Young's inference runs the other way: from data to the phase rule
      , Edge.entails
          [darkCentreReading, waveSuperposition, opticalPathDifference]
          relativePhaseAirGap
          "Zero path difference yet darkness means an extra half-cycle difference (Young)."
      , Edge.entails
          [blackFilmReading, topIsThin, waveSuperposition, opticalPathDifference]
          relativePhaseSoap
          "A film far thinner than λ reflects almost nothing, so the two reflections must differ by a half cycle."

        -- unification
      , Edge.entails
          [thinFilmCondition, airGapCondition, reflectionPhaseRule, lloydDarkEdgeReading]
          unifiedThinFilmTheory
          "One phase rule and one superposition principle cover films, rings and Lloyd's mirror."

        -- rivals
      , Edge.nogood [pigmentModel, absorptionIsMonotonic, periodicBrightnessReading]
          "Pigment absorption is monotonic in thickness, but the observed brightness is periodic."
      , Edge.nogood
          [noPhaseShiftModel, waveSuperposition, opticalPathDifference, topIsThin, blackFilmReading]
          "With no phase shift the thinnest film would reinforce (bright), but it is observed black."
      , Edge.contradicts noPhaseShiftModel relativePhaseSoap
          "The rival denies exactly the half-cycle shift the soap-film condition needs."
      ] }

/-! ## Granted bundles and checks -/

def interferenceLaws : List Theory :=
  [waveSuperposition, snellLaw, wavelengthInMedium, reflectionPhaseRule,
   energyConservation, whiteLightIsMixture, filmGeometry, soapFilmSetup,
   airGapSetup, lloydSetup, drainageWedge, topIsThin]

-- Verification: the laws support all seven raw records
#guard evidenceGraph.supports interferenceLaws whiteLightFilmExperiment
#guard evidenceGraph.supports interferenceLaws monochromaticFilmExperiment
#guard evidenceGraph.supports interferenceLaws blackFilmExperiment
#guard evidenceGraph.supports interferenceLaws viewingAngleExperiment
#guard evidenceGraph.supports interferenceLaws newtonRingsExperiment
#guard evidenceGraph.supports interferenceLaws transmissionExperiment
#guard evidenceGraph.supports interferenceLaws lloydMirrorExperiment

-- The derived laws and the unification follow from the granted laws
#guard (evidenceGraph.derive interferenceLaws).contains thinFilmCondition
#guard (evidenceGraph.derive interferenceLaws).contains airGapCondition
#guard (evidenceGraph.derive interferenceLaws).contains unifiedThinFilmTheory

-- Duhem–Quine: drop the phase rule and the soap-film condition no longer follows
#guard !(evidenceGraph.derive
  [waveSuperposition, snellLaw, wavelengthInMedium, filmGeometry, soapFilmSetup]).contains
  thinFilmCondition
-- ... and without it the black film is not predicted
#guard !evidenceGraph.supports
  [waveSuperposition, snellLaw, wavelengthInMedium, filmGeometry, soapFilmSetup, topIsThin]
  blackFilmExperiment

-- Young's direction: data alone (plus wave principle) gives the phase shift
#guard (evidenceGraph.derive
  [darkCentreReading, waveSuperposition, snellLaw, filmGeometry]).contains relativePhaseAirGap

-- Rivals are refuted
#guard evidenceGraph.refutes
  [pigmentModel, absorptionIsMonotonic] monochromaticFilmExperiment
#guard evidenceGraph.refutes
  [noPhaseShiftModel, waveSuperposition, snellLaw, filmGeometry, topIsThin] blackFilmExperiment
#guard evidenceGraph.exclusive noPhaseShiftModel relativePhaseSoap
#guard !evidenceGraph.inconsistent interferenceLaws

#guard evidenceGraph.wellFormed

end Scilib.SoapFilm
