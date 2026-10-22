import Scilib.Basic

/-!
# Rainbow: reflection, refraction, dispersion, polarisation and interference in one graph

History in one paragraph: Aristotle (c. 350 BCE) described the bow as a reflection;
Alexander of Aphrodisias (c. 200 CE) noticed the dark band between the two bows;
Ibn Sahl (c. 984) and later Descartes (1637) found the law of refraction; Theodoric of
Freiberg and Kamal al-Din al-Farisi (c. 1304-1310) traced rays through a water-filled
sphere; Descartes computed the 42° and 51° bows; Newton (1672) explained the colours by
dispersion; Young (1803) explained the faint inner bands by interference; Airy (1838)
gave the wave theory of the bow; Nussenzveig (1977) gave the modern account.

Layers :
experiments -> readings -> laws (via auxiliaries) -> predictions -> corroboration -> verdict.
Two rivals, `simpleMirrorModel` and `pureRayOptics`, are refuted by the data.
-/

namespace Scilib.Rainbow

/-! ## Raw experiments -/

def reflectionExperiment : Experiment :=
  { protocol := "Send narrow beams of several colours onto a plane mirror and measure the angles of the incident and reflected beams from the surface normal at several incidence angles."
    observation := "For every colour the two angles are equal within measurement error, and the reflected beam stays in the plane containing the incident beam and the normal."
    sources := ["Euclid (attributed), Catoptrics, c. 300 BCE", "Hero of Alexandria, Catoptrica, 1st century CE"] }

def refractionExperiment : Experiment :=
  { protocol := "Send a narrow beam from air into still water and record the angle of incidence and the angle of refraction for several incidence angles."
    observation := "The refraction angle is always smaller than the incidence angle, and sin(incidence) / sin(refraction) stays constant at about 1.33 for every angle."
    sources := ["Ptolemy, Optics, c. 150 CE (first tabulated angles)", "Ibn Sahl, On Burning Mirrors and Lenses, c. 984", "R. Descartes, La Dioptrique, 1637"] }

def prismExperiment : Experiment :=
  { protocol := "Pass a narrow beam of sunlight through a glass prism onto a screen, then select one colour of the spread beam with a slit and send it through a second prism."
    observation := "Sunlight spreads into an ordered band of colours with violet deviated most and red least; a single selected colour is deviated by the second prism but not spread further."
    sources := ["I. Newton, Philosophical Transactions 6(80), 1672", "I. Newton, Opticks, 1704"] }

def brewsterExperiment : Experiment :=
  { protocol := "Reflect unpolarised light from a glass or water surface at different angles of incidence and examine the reflected beam through a rotating polarising filter."
    observation := "The reflected light is partly polarised perpendicular to the plane of incidence, and almost fully polarised at the incidence angle where tan(angle) equals n2 / n1."
    sources := ["E.-L. Malus, 1808-1809 (polarisation by reflection)", "D. Brewster, Philosophical Transactions, 1815"] }

def youngExperiment : Experiment :=
  { protocol := "Pass sunlight through a narrow slit and then through two close parallel slits, and observe the light on a distant screen."
    observation := "Alternating bright and dark fringes appear, and the fringe spacing is larger for red light than for violet light."
    sources := ["T. Young, Philosophical Transactions, 1804 (Bakerian Lecture of 1803)"] }

def glassSphereExperiment : Experiment :=
  { protocol := "Hold a large water-filled glass sphere in sunlight, view it from different directions, and cover parts of its surface to see which entering rays produce which colours."
    observation := "Colours appear only from rays that enter the sphere, reflect once off its back inner surface and leave; a second, fainter set of colours comes from rays reflected twice inside, with the colour order reversed."
    sources := ["Theodoric of Freiberg, De iride et radialibus impressionibus, c. 1304-1310", "Kamal al-Din al-Farisi, Tanqih al-Manazir, c. 1309", "R. Descartes, Les Meteores, 1637"] }

def rainbowSkyExperiment : Experiment :=
  { protocol := "With the Sun behind the observer, measure the angle between the antisolar direction (the line from the Sun through the observer's head) and the bright bows, and note their colour order and the brightness of the sky between them."
    observation := "A primary bow is seen about 42° from the antisolar point with red on the outside; a fainter secondary bow appears about 51° from it with the colours reversed, and the sky between the two bows is darker."
    sources := ["Aristotle, Meteorologica, c. 350 BCE", "Alexander of Aphrodisias, On Aristotle's Meteorology, c. 200 CE", "H. M. Nussenzveig, Scientific American 236(4), 1977"] }

def polarisationExperiment : Experiment :=
  { protocol := "View a bright primary bow through a polarising filter and rotate the filter through a full turn, noting the brightness of the bow."
    observation := "The bow's brightness changes strongly with the filter angle: it is brightest when the filter's transmission axis is tangent to the arc and nearly vanishes when the axis points along the radius."
    sources := ["M. Minnaert, Light and Colour in the Open Air, 1954"] }

def supernumeraryExperiment : Experiment :=
  { protocol := "In rain made of small, fairly uniform drops, examine the sky just inside the primary bow."
    observation := "A few faint, alternating pink and green bands are seen just inside the primary bow."
    sources := ["T. Young, Philosophical Transactions, 1804", "G. B. Airy, Transactions of the Cambridge Philosophical Society 6, 1838"] }

/-! ## Readings: theories that interpret the raw records -/

def reflectionReading : Theory :=
  { statement := "A reflected ray makes the same angle with the surface normal as the incident ray, for every colour, and lies in the plane of incidence." }

def refractionReading : Theory :=
  { statement := "A ray passing from air into water satisfies sin(incidence) / sin(refraction) = 1.33 at every incidence angle." }

def prismReading : Theory :=
  { statement := "In a glass prism, different colours of light are refracted by different amounts, violet most and red least, and each colour keeps its own refraction." }

def brewsterReading : Theory :=
  { statement := "Light reflected from a transparent surface is polarised perpendicular to the plane of incidence, completely so when tan(angle of incidence) = n2 / n1." }

def youngReading : Theory :=
  { statement := "Light from two close slits forms alternating bright and dark fringes whose spacing depends on colour." }

def glassSphereReading : Theory :=
  { statement := "Colour from a water-filled sphere comes from rays that refract in, reflect once internally and refract out, with a second, reversed-colour set from two internal reflections." }

def rainbowSkyReading : Theory :=
  { statement := "The primary bow lies about 42° from the antisolar point with red outside; the secondary bow lies about 51° from it with red inside; the sky between them is darker." }

def polarisationReading : Theory :=
  { statement := "Light from the primary bow is strongly polarised tangentially to the arc." }

def supernumeraryReading : Theory :=
  { statement := "Faint repeating coloured bands lie just inside the primary bow." }

/-! ## Auxiliary hypotheses and criteria -/

def inductiveGeneralisation : Theory :=
  { statement := "Regularities found in careful, repeated measurements hold in all similar situations." }

def dispersionIsGeneral : Theory :=
  { statement := "The colour dependence of refraction seen in a glass prism also holds in water." }

def dropAssumptions : Theory :=
  { statement := "Raindrops are nearly spherical, much larger than the wavelength of light, and lit by parallel sunlight." }

def rayConcentration : Theory :=
  { statement := "Rays whose deviation is stationary against impact position leave nearly parallel, so light intensity piles up at the minimum deviation angle." }

def agreementCriterion : Theory :=
  { statement := "A model is corroborated by an observation when its derived prediction agrees with the interpreted observation within measurement uncertainty." }

def comparativeCriterion : Theory :=
  { statement := "Between these stated alternatives, prefer the model that accounts for more independent observations with fewer extra assumptions." }

/-! ## Laws established from the lab experiments -/

def lawOfReflection : Theory :=
  { statement := "At a smooth surface the angle of reflection equals the angle of incidence for every colour, in the plane of incidence." }

def snellsLaw : Theory :=
  { statement := "At the boundary between media of refractive indices n1 and n2, n1 sin(θ1) = n2 sin(θ2)." }

def waterDispersion : Theory :=
  { statement := "In water, violet light is refracted more strongly than red light (n about 1.343 versus about 1.331)."
    sources := ["CRC Handbook of Chemistry and Physics (refractive index of water against wavelength)"] }

def fresnelBrewster : Theory :=
  { statement := "Light reflected at a transparent boundary is polarised perpendicular to the plane of incidence, fully so at Brewster's angle, tan(θB) = n2 / n1." }

def waveInterference : Theory :=
  { statement := "Light waves arriving along different paths add up, giving bright and dark fringes according to their path difference." }

/-! ## Predictions of the raindrop model -/

def dropRayPaths : Theory :=
  { statement := "In a spherical drop, a ray can leave after one internal reflection (primary path) or two (secondary path), with a refraction on entry and on exit." }

def deviationFormulas : Theory :=
  { statement := "With incidence angle i and refraction angle r, the primary path deviates a ray by D = 180° + 2i − 4r and the secondary path by D = 360° + 2i − 6r." }

def bowAngles : Theory :=
  { statement := "For n about 1.33, deviation is minimal at cos²(i) = (n² − 1) / 3 on the primary path and (n² − 1) / 8 on the secondary path, putting bright bows about 42° and about 51° from the antisolar point." }

def colourOrders : Theory :=
  { statement := "Since violet refracts more than red, the primary bow has red at about 42.4° (outside) and violet at about 40.6° (inside), and the secondary bow has red at about 50.4° (inside) and violet at about 53.5° (outside)." }

def darkBand : Theory :=
  { statement := "No primary or secondary ray reaches between about 42.4° and 50.4° from the antisolar point, so the sky between the bows is darker (Alexander's dark band)." }

def polarisationPrediction : Theory :=
  { statement := "At the primary bow's internal reflection the angle is about 40°, near the internal Brewster angle of about 37°, so the bow's light is strongly polarised tangentially." }

def supernumeraryPrediction : Theory :=
  { statement := "Just inside the primary bow, two different rays leave a drop in the same direction along paths of different length, and their interference gives faint alternating bands." }

/-! ## Corroboration and verdict -/

def rayPathsCorroborated : Theory :=
  { statement := "The one- and two-internal-reflection ray paths agree with the water-filled sphere experiment." }

def bowGeometryCorroborated : Theory :=
  { statement := "The predicted bow angles, colour orders and dark band agree with the observed bows." }

def polarisationCorroborated : Theory :=
  { statement := "The predicted tangential polarisation agrees with the observed polarisation of the bow." }

def supernumeraryCorroborated : Theory :=
  { statement := "The predicted interference bands agree with the observed faint bands inside the primary bow." }

def raindropModelSupported : Theory :=
  { statement := "The raindrop model, combining refraction, internal reflection, dispersion, polarisation and interference, is better supported than a simple mirror reflection as the explanation of rainbows." }

/-! ## Rivals -/

def simpleMirrorModel : Theory :=
  { statement := "A rainbow is a simple mirror-like reflection of the Sun from cloud or mist, with no refraction in the drops." }

def pureRayOptics : Theory :=
  { statement := "Light travels only as non-interfering geometric rays, so intensity varies smoothly with deviation and has no fringes." }

def evidenceGraph : Graph :=
  { edges :=
      [ -- experiments to readings
        Edge.interprets reflectionReading reflectionExperiment
          "Equal incidence and reflection angles for each colour are recorded as the measured result."
      , Edge.interprets refractionReading refractionExperiment
          "The constant sine ratio is read as the refractive index of water."
      , Edge.interprets prismReading prismExperiment
          "Colour-dependent deviation is read as colour-dependent refraction."
      , Edge.interprets brewsterReading brewsterExperiment
          "The polarisation of reflected light is read as a rule about reflection."
      , Edge.interprets youngReading youngExperiment
          "The fringe pattern is read as interference of light."
      , Edge.interprets glassSphereReading glassSphereExperiment
          "The colour-producing rays are read as the path through the sphere."
      , Edge.interprets rainbowSkyReading rainbowSkyExperiment
          "The measured angles, colour order and dark band are recorded as the bow geometry."
      , Edge.interprets polarisationReading polarisationExperiment
          "The filter response is read as tangential polarisation."
      , Edge.interprets supernumeraryReading supernumeraryExperiment
          "The faint bands are read as extra bows inside the primary bow."
        -- readings to laws
      , Edge.entails [reflectionReading, inductiveGeneralisation] lawOfReflection
          "The measured equality is generalised to all smooth surfaces and colours."
      , Edge.entails [refractionReading, inductiveGeneralisation] snellsLaw
          "The constant sine ratio is generalised into the law of refraction."
      , Edge.entails [prismReading, dispersionIsGeneral, inductiveGeneralisation] waterDispersion
          "Colour-dependent refraction in glass is carried over to water."
      , Edge.entails [brewsterReading, inductiveGeneralisation] fresnelBrewster
          "The measured polarisation rule is generalised to all transparent boundaries."
      , Edge.entails [youngReading, inductiveGeneralisation] waveInterference
          "The fringe pattern is generalised into a wave-interference law."
        -- laws to predictions
      , Edge.entails [lawOfReflection, snellsLaw, dropAssumptions] dropRayPaths
          "Reflection and refraction at a spherical drop give the one- and two-reflection exit paths."
      , Edge.entails [dropRayPaths, lawOfReflection, snellsLaw] deviationFormulas
          "Adding the bends at each surface gives the total deviation of each path."
      , Edge.entails [deviationFormulas, rayConcentration, refractionReading] bowAngles
          "Minimising the deviation with n = 1.33 gives the bright bow angles."
      , Edge.entails [bowAngles, waterDispersion] colourOrders
          "A colour-dependent index moves each colour's minimum deviation."
      , Edge.entails [deviationFormulas, colourOrders] darkBand
          "Minimum deviation stops the primary rays and starts the secondary ones."
      , Edge.entails [fresnelBrewster, dropRayPaths, bowAngles] polarisationPrediction
          "The internal reflection angle sits near Brewster's angle."
      , Edge.entails [deviationFormulas, bowAngles, waveInterference] supernumeraryPrediction
          "Two rays with equal deviation but different path lengths interfere."
        -- predictions meet observations
      , Edge.entails [dropRayPaths, glassSphereReading, agreementCriterion] rayPathsCorroborated
          "The predicted ray paths match the sphere experiment."
      , Edge.entails [bowAngles, colourOrders, darkBand, rainbowSkyReading, agreementCriterion]
          bowGeometryCorroborated
          "Angles, colour order and dark band all match the sky measurements."
      , Edge.entails [polarisationPrediction, polarisationReading, agreementCriterion]
          polarisationCorroborated
          "The predicted polarisation matches the filter measurement."
      , Edge.entails [supernumeraryPrediction, supernumeraryReading, agreementCriterion]
          supernumeraryCorroborated
          "The predicted interference bands match the faint inner bands."
      , Edge.entails [rayPathsCorroborated, bowGeometryCorroborated, polarisationCorroborated,
          supernumeraryCorroborated, comparativeCriterion] raindropModelSupported
          "One drop model accounts for four independent kinds of observation."
        -- rivals
      , Edge.nogood [simpleMirrorModel, lawOfReflection, rainbowSkyReading]
          "A pure reflection is colour-blind, yet the bow shows ordered colours at fixed angles."
      , Edge.contradicts pureRayOptics supernumeraryReading
          "Non-interfering rays give a smooth intensity with no extra bands inside the bow."
      , Edge.contradicts pureRayOptics waveInterference
          "Pure rays and interference of light cannot both hold."
      , Edge.contradicts simpleMirrorModel raindropModelSupported
          "A colour-blind mirror reflection and a refraction-based raindrop model cannot both explain the bow."
      ] }

/-! ## Granted bundles -/

def foundationEvidence : List Theory :=
  [reflectionReading, refractionReading, prismReading, brewsterReading, youngReading,
    inductiveGeneralisation, dispersionIsGeneral]

def combinedEvidence : List Theory :=
  foundationEvidence ++
    [dropAssumptions, rayConcentration, glassSphereReading, rainbowSkyReading,
      polarisationReading, supernumeraryReading, agreementCriterion, comparativeCriterion]

/-! ## Checks -/

-- the five lab laws follow from the five lab experiments
#guard (evidenceGraph.derive foundationEvidence).contains lawOfReflection
#guard (evidenceGraph.derive foundationEvidence).contains snellsLaw
#guard (evidenceGraph.derive foundationEvidence).contains waterDispersion
#guard (evidenceGraph.derive foundationEvidence).contains fresnelBrewster
#guard (evidenceGraph.derive foundationEvidence).contains waveInterference

-- the laws combine into rainbow predictions and the final verdict
#guard (evidenceGraph.derive combinedEvidence).contains dropRayPaths
#guard (evidenceGraph.derive combinedEvidence).contains bowAngles
#guard (evidenceGraph.derive combinedEvidence).contains colourOrders
#guard (evidenceGraph.derive combinedEvidence).contains darkBand
#guard (evidenceGraph.derive combinedEvidence).contains polarisationPrediction
#guard (evidenceGraph.derive combinedEvidence).contains supernumeraryPrediction
#guard (evidenceGraph.derive combinedEvidence).contains raindropModelSupported

-- supports: the faint-band record is only supported once its reading is granted
#guard evidenceGraph.supports combinedEvidence supernumeraryExperiment
#guard !(evidenceGraph.supports foundationEvidence supernumeraryExperiment)

-- Duhem-Quine: drop one auxiliary and the conclusion no longer follows
#guard !(evidenceGraph.derive [reflectionReading, refractionReading, prismReading]).contains snellsLaw
#guard !(evidenceGraph.derive [prismReading, inductiveGeneralisation]).contains waterDispersion
#guard !(evidenceGraph.derive (foundationEvidence ++ [dropAssumptions])).contains bowAngles
#guard !(evidenceGraph.derive
  (combinedEvidence.filter (· != comparativeCriterion))).contains raindropModelSupported

-- refutation of the rivals
#guard evidenceGraph.refutes [simpleMirrorModel, lawOfReflection] rainbowSkyExperiment
#guard evidenceGraph.refutes [pureRayOptics] supernumeraryExperiment
#guard evidenceGraph.refutes [pureRayOptics, inductiveGeneralisation] youngExperiment
#guard !(evidenceGraph.refutes [pureRayOptics] youngExperiment)
#guard evidenceGraph.exclusive simpleMirrorModel raindropModelSupported
#guard evidenceGraph.wellFormed

end Scilib.Rainbow
