import Scilib.Basic

/-!
# John Snow and cholera, London 1854: is there a real control?

Domain #8 (causal intervention and controls).  Source facts and their verification:
`parth/sources/john-snow-and-cholera-london-1854/` (ledger.json, REPORT.md).  Primary source: John Snow,
"On the mode of communication of cholera", 2nd edition (London, 1855).  Secondary sources: Wikipedia
(1854 Broad Street cholera outbreak, John Snow, Miasma theory, William Farr).

Graph shape (as in `TheEtherAnd.lean`):

* rivals: `waterborne` (Snow), `miasma`, `contact` and `elevation` (Farr);
* six observations, each with its `interprets` edge: the Broad Street map, the brewery, the workhouse,
  the Hampstead widow, the pump-handle removal and the two water companies;
* the brewery, the workhouse and the widow are natural comparisons.  Each refutes a rival only together
  with a hidden assumption (`sameAir`, `noHiddenContact`) and a data assumption (`recordsAccurate`);
* the two water companies mix their pipes in the same streets, so the rival places-and-people theories
  predict one death rate for both; the 8-to-9-fold difference refutes them, but only if the houses are
  alike (`groupsAlike`) and each death went to the right company (`waterSupplyKnown`);
* the pump-handle removal is not a clean test: the attacks had already fallen and the population had fled,
  so two readings of the same record exist and no rival is refuted by it.

Not modelled: Snow's study of Guy's table (medical men and undertakers), the percussion-cap factory, deep
well buildings that escaped, the 1849 epidemic, and the later Board of Health inquiry.
-/

namespace Scilib.JohnSnowAnd

/-! ## Rivals -/

def waterborne : Theory :=
  { statement := "Water-borne cholera (Snow): cholera is propagated by a morbid poison entering the alimentary canal, and the cholera evacuations mixed with the water used for drinking can carry it to many people."
    sources := ["Snow 1855"] }

def miasma : Theory :=
  { statement := "Miasma: cholera is caused by particles in the air, or miasmata, which arise from decomposing matter and are breathed in by the people who live there."
    sources := ["Wikipedia, 1854 Broad Street cholera outbreak", "Wikipedia, miasma theory", "Wikipedia, William Farr"] }

def contact : Theory :=
  { statement := "Contact with the sick: cholera is propagated by effluvia given off from the patient or the dead body, so it passes to the people who attend them."
    sources := ["Snow 1855"] }

def elevation : Theory :=
  { statement := "Farr's elevation theory: cholera mortality is highest in the lowest districts of London, and the level of the soil has some direct influence on the disease."
    sources := ["Snow 1855", "Wikipedia, William Farr"] }

/-! ## Hidden assumptions (status recorded in `sources`) -/

def pumpPolluted : Theory :=
  { statement := "The water of the Broad Street pump was contaminated: the well was later found to lie 3 feet from an old cesspit that had begun to leak faecal bacteria, though Snow's chemical and microscope examination of the water did not conclusively prove its danger."
    sources := ["status: discovered", "Snow 1855", "Wikipedia, 1854 Broad Street cholera outbreak", "Wikipedia, John Snow"] }

def notFromPump : Theory :=
  { statement := "The brewery workmen and the workhouse inmates did not take their drinking water from the Broad Street pump."
    sources := ["Snow 1855"] }

def sameAir : Theory :=
  { statement := "The brewery workmen and the workhouse inmates breathe the same air as the people in the streets around them."
    sources := ["status: suspected", "Snow 1855"] }

def noHiddenContact : Theory :=
  { statement := "No cholera patient or dead body had come near the Hampstead widow or her niece."
    sources := ["status: suspected", "Snow 1855"] }

def groupsAlike : Theory :=
  { statement := "The houses and the people supplied by the two water companies are alike in condition, occupation and every physical surrounding."
    sources := ["status: declared", "Snow 1855"] }

def waterDiffers : Theory :=
  { statement := "The Southwark and Vauxhall Company took water from sewage-polluted sections of the Thames, while the Lambeth Company took cleaner water from further upriver."
    sources := ["Wikipedia, 1854 Broad Street cholera outbreak", "Wikipedia, John Snow", "Snow 1855"] }

def waterSupplyKnown : Theory :=
  { statement := "Each cholera death was assigned to the right water company, using the receipt for the water-rate or a chemical test of the water when the residents could not say."
    sources := ["status: declared", "Snow 1855"] }

def recordsAccurate : Theory :=
  { statement := "The registered cholera deaths and their addresses are accurate enough for Snow's map and counts."
    sources := ["status: declared", "Snow 1855"] }

/-! ## Predictions and readings -/

def airPrediction : Theory :=
  { statement := "If cholera spreads through the air of a place, the brewery workmen and the workhouse inmates, who share the air of the stricken streets, should die at about the rate of the streets around them."
    sources := ["status: inference", "Snow 1855"] }

def contactPrediction : Theory :=
  { statement := "If cholera passes only by contact with the sick or the dead, nobody who had no such contact should fall ill."
    sources := ["status: inference", "Snow 1855"] }

def samePlaceSameRate : Theory :=
  { statement := "Houses mixed together in the same streets and alike in every other way should have about the same cholera death rate, whichever water company supplies them."
    sources := ["status: inference", "Snow 1855"] }

def pumpCluster : Theory :=
  { statement := "Cholera deaths clustered around the Broad Street pump, and there was no increase of cholera in that part of London except among the people who drank its water."
    sources := ["Snow 1855"] }

def breweryEscaped : Theory :=
  { statement := "The more than seventy workmen of the brewery next to the pump suffered no severe cholera."
    sources := ["Snow 1855"] }

def workhouseSpared : Theory :=
  { statement := "Only five of the 535 workhouse inmates died of cholera, though the workhouse was surrounded by houses in which people died of it."
    sources := ["Snow 1855"] }

def widowFar : Theory :=
  { statement := "A widow at Hampstead and her niece in Islington died of cholera after drinking Broad Street pump water, though there was no cholera at the time at West End or where the niece died."
    sources := ["Snow 1855"] }

def fallBeforeHandle : Theory :=
  { statement := "The attacks had so far diminished before the use of the water was stopped that it is impossible to decide whether the well still contained the cholera poison in an active state."
    sources := ["Snow 1855", "Wikipedia, 1854 Broad Street cholera outbreak"] }

def flightReading : Theory :=
  { statement := "The mortality was much diminished by the flight of the population, which commenced soon after the outbreak."
    sources := ["Snow 1855"] }

def companyDifference : Theory :=
  { statement := "The mortality in the houses supplied by the Southwark and Vauxhall Company was between eight and nine times as great as in the houses supplied by the Lambeth Company."
    sources := ["Snow 1855"] }

/-! ## Experiments -/

def broadStreetMap : Experiment :=
  { protocol := "Snow marked on a map every cholera death registered from 19 August to 30 September 1854 in the locality, and was informed by the families of the dead whether they had drunk water from the Broad Street pump."
    observation := "Nearly all the deaths took place within a short distance of the pump, and ten were in houses decidedly nearer another street pump; in 61 instances the deceased used to drink the pump water, in six they did not, and in six no information could be had."
    sources := ["Snow 1855"] }

def brewery : Experiment :=
  { protocol := "Snow called on the proprietor of the brewery in Broad Street, near the pump, on perceiving that no brewer's men were registered as having died of cholera."
    observation := "The proprietor said there were above seventy workmen, none of whom had suffered from cholera in a severe form and only two of whom were indisposed, not seriously; the men are allowed a certain quantity of malt liquor, he was quite certain they never obtained water from the pump in the street, and there is a deep well in the brewery."
    sources := ["Snow 1855"] }

def workhouse : Experiment :=
  { protocol := "Snow noted the deaths among the 535 inmates of the workhouse in Poland Street."
    observation := "Only five of the 535 inmates died of cholera, though the workhouse is surrounded by houses in which deaths from cholera occurred; it has a pump-well on the premises, in addition to the supply from the Grand Junction Waterworks, and the inmates never sent to Broad Street for water."
    sources := ["Snow 1855"] }

def hampsteadWidow : Experiment :=
  { protocol := "Snow followed up a death registered at West End, Hampstead, on 2 September, and was informed by the dead woman's son."
    observation := "The woman, a widow aged 59, had not been in the neighbourhood of Broad Street for many months; it was the custom to take out a large bottle of the pump water as she preferred it, she drank it in the evening and also on Friday, was seized with cholera on the evening of the latter day and died on Saturday; a niece on a visit also drank the water, returned to a high and healthy part of Islington, was attacked with cholera and died."
    sources := ["Snow 1855"] }

def handleRemoval : Experiment :=
  { protocol := "On 7 September 1854 Snow represented the circumstances to the Board of Guardians of St. James's parish, and the handle of the Broad Street pump was removed on the following day."
    observation := "The greatest number of attacks in one day was on 1 September, falling from 143 to 116 the next day and then to 54; on 8 September, the day the handle was removed, there were twelve attacks, and on the next four days eleven, five, five and one, and never more than four on one day afterwards."
    sources := ["Snow 1855"] }

def companies : Experiment :=
  { protocol := "Snow took the addresses of persons dying of cholera in districts where the pipes of the Southwark and Vauxhall Company and the Lambeth Company go down all the same streets, and learned which company supplied each house from the water-rate receipt or a chemical test of the water."
    observation := "In the first seven weeks of the 1854 epidemic there were 1,263 deaths from cholera in 40,046 houses supplied by the Southwark and Vauxhall Company (315 in each 10,000 houses) and 98 deaths in 26,107 houses supplied by the Lambeth Company (37 in each 10,000 houses)."
    sources := ["Snow 1855"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- observations and their readings
        Edge.interprets pumpCluster broadStreetMap
      , Edge.interprets breweryEscaped brewery
      , Edge.interprets workhouseSpared workhouse
      , Edge.interprets widowFar hampsteadWidow
      , Edge.interprets fallBeforeHandle handleRemoval
      , Edge.interprets flightReading handleRemoval
      , Edge.interprets companyDifference companies
      -- Snow's water-borne cholera explains each comparison
      , Edge.entails [waterborne, pumpPolluted] pumpCluster
          "Everyone who drank from the polluted pump was exposed, so the deaths cluster round it."
      , Edge.entails [waterborne, pumpPolluted, notFromPump] breweryEscaped
          "The brewery men drank malt liquor and their own well, not the pump water."
      , Edge.entails [waterborne, pumpPolluted, notFromPump] workhouseSpared
          "The workhouse had its own pump-well and sent nobody to Broad Street."
      , Edge.entails [waterborne, pumpPolluted] widowFar
          "The bottled pump water carried the poison to places with no cholera."
      , Edge.entails [waterborne, waterDiffers] companyDifference
          "One company drew sewage-laden water, the other water from beyond the reach of the sewage."
      -- miasma is refuted by the brewery and the workhouse, if they breathe the same air
      , Edge.entails [miasma, sameAir] airPrediction
          "Inference by the graph author: the same air means the same exposure, so the same death rate."
      , Edge.nogood [airPrediction, breweryEscaped, recordsAccurate]
          "Seventy workmen beside the pump escaped, where the air prediction expects deaths."
      , Edge.nogood [airPrediction, workhouseSpared, recordsAccurate]
          "Five deaths among 535 inmates, where over a hundred were expected at the street rate."
      -- contact is refuted by the widow, if she met no patient
      , Edge.entails [contact, noHiddenContact] contactPrediction
          "Inference by the graph author: without contact with the sick or the dead there is no way to catch it."
      , Edge.nogood [contactPrediction, widowFar]
          "Two people with no contact died after drinking pump water carried to them."
      -- the three place-and-people rivals predict one rate for the two companies
      , Edge.entails [elevation, groupsAlike] samePlaceSameRate
          "Houses in the same streets stand at the same level of ground."
      , Edge.entails [miasma, groupsAlike] samePlaceSameRate
          "Houses in the same streets breathe the same air."
      , Edge.entails [contact, groupsAlike] samePlaceSameRate
          "Alike houses and people give the same chances of meeting the sick."
      , Edge.nogood [samePlaceSameRate, companyDifference, waterSupplyKnown]
          "A difference of eight to nine times between mixed houses, if each death went to the right company."
      ] }

/-! ## Checks: what `lake build` verifies -/

/-- Named checks; the verifier mutates the graph and runs these on every mutant. -/
def checks (g : Graph) : List (String × Bool) :=
  [ ("graph is well formed", g.wellFormed)
    -- readings
  , ("map reading", g.readings.contains (pumpCluster, broadStreetMap))
  , ("brewery reading", g.readings.contains (breweryEscaped, brewery))
  , ("workhouse reading", g.readings.contains (workhouseSpared, workhouse))
  , ("widow reading", g.readings.contains (widowFar, hampsteadWidow))
  , ("handle reading: attacks already falling", g.readings.contains (fallBeforeHandle, handleRemoval))
  , ("handle reading: flight of the population", g.readings.contains (flightReading, handleRemoval))
  , ("companies reading", g.readings.contains (companyDifference, companies))
    -- the pump explains the map, the brewery, the workhouse and the widow
  , ("water-borne cholera explains the map", g.supports [waterborne, pumpPolluted] broadStreetMap)
  , ("the map needs the polluted pump", !(g.derive [waterborne]).contains pumpCluster)
  , ("the map needs the water-borne theory", !(g.derive [pumpPolluted]).contains pumpCluster)
  , ("water-borne cholera explains the brewery", g.supports [waterborne, pumpPolluted, notFromPump] brewery)
  , ("the brewery needs its own water", !(g.derive [waterborne, pumpPolluted]).contains breweryEscaped)
  , ("the brewery needs the polluted pump", !(g.derive [waterborne, notFromPump]).contains breweryEscaped)
  , ("the brewery needs the water-borne theory", !(g.derive [pumpPolluted, notFromPump]).contains breweryEscaped)
  , ("water-borne cholera explains the workhouse", g.supports [waterborne, pumpPolluted, notFromPump] workhouse)
  , ("the workhouse needs its own well", !(g.derive [waterborne, pumpPolluted]).contains workhouseSpared)
  , ("the workhouse needs the polluted pump", !(g.derive [waterborne, notFromPump]).contains workhouseSpared)
  , ("the workhouse needs the water-borne theory", !(g.derive [pumpPolluted, notFromPump]).contains workhouseSpared)
  , ("water-borne cholera explains the widow", g.supports [waterborne, pumpPolluted] hampsteadWidow)
  , ("the widow needs the polluted pump", !(g.derive [waterborne]).contains widowFar)
  , ("the widow needs the water-borne theory", !(g.derive [pumpPolluted]).contains widowFar)
    -- miasma: the map alone spares it, the brewery and the workhouse refute it
  , ("the map alone does not refute miasma", !g.refutes [miasma, sameAir, recordsAccurate] broadStreetMap)
  , ("the brewery refutes miasma", g.refutes [miasma, sameAir, recordsAccurate] brewery)
  , ("the workhouse refutes miasma", g.refutes [miasma, sameAir, recordsAccurate] workhouse)
  , ("blame: the refutation needs accurate records", !g.refutes [miasma, sameAir] brewery)
  , ("blame: the refutation needs the same air", !g.refutes [miasma, recordsAccurate] brewery)
  , ("blame: the workhouse needs accurate records", !g.refutes [miasma, sameAir] workhouse)
  , ("blame: the workhouse needs the same air", !g.refutes [miasma, recordsAccurate] workhouse)
  , ("accurate records alone refute nothing", !g.refutes [recordsAccurate] brewery)
  , ("accurate records alone refute nothing here either", !g.refutes [recordsAccurate] workhouse)
  , ("the air prediction needs miasma", !(g.derive [sameAir]).contains airPrediction)
  , ("the air prediction needs the same air", !(g.derive [miasma]).contains airPrediction)
  , ("the air prediction alone is consistent", !g.inconsistent [miasma, sameAir, recordsAccurate])
  , ("the workhouse alone does not refute miasma without the air", !g.refutes [miasma] workhouse)
    -- contact: the widow refutes it
  , ("the widow refutes contact", g.refutes [contact, noHiddenContact] hampsteadWidow)
  , ("blame: the widow needs no hidden contact", !g.refutes [contact] hampsteadWidow)
  , ("blame: the widow needs the contact theory", !g.refutes [noHiddenContact] hampsteadWidow)
  , ("the contact prediction needs contact", !(g.derive [noHiddenContact]).contains contactPrediction)
  , ("the contact prediction needs no hidden contact", !(g.derive [contact]).contains contactPrediction)
  , ("the contact prediction alone is consistent", !g.inconsistent [contact, noHiddenContact])
  , ("water-borne cholera survives the widow", !g.refutes [waterborne, pumpPolluted] hampsteadWidow)
    -- the two water companies
  , ("water-borne cholera explains the companies", g.supports [waterborne, waterDiffers] companies)
  , ("the companies need the water difference", !(g.derive [waterborne]).contains companyDifference)
  , ("the companies need the water-borne theory", !(g.derive [waterDiffers]).contains companyDifference)
  , ("the companies refute the elevation theory", g.refutes [elevation, groupsAlike, waterSupplyKnown] companies)
  , ("the companies refute miasma", g.refutes [miasma, groupsAlike, waterSupplyKnown] companies)
  , ("the companies refute contact", g.refutes [contact, groupsAlike, waterSupplyKnown] companies)
  , ("blame: the companies need alike groups", !g.refutes [elevation, waterSupplyKnown] companies)
  , ("blame: the companies need the right attribution", !g.refutes [elevation, groupsAlike] companies)
  , ("the attribution alone refutes nothing", !g.refutes [waterSupplyKnown] companies)
  , ("the companies alone do not refute the elevation theory without its prediction",
      !g.refutes [elevation, groupsAlike, waterSupplyKnown] broadStreetMap)
  , ("the elevation theory predicts one rate", (g.derive [elevation, groupsAlike]).contains samePlaceSameRate)
  , ("miasma predicts one rate", (g.derive [miasma, groupsAlike]).contains samePlaceSameRate)
  , ("contact predicts one rate", (g.derive [contact, groupsAlike]).contains samePlaceSameRate)
  , ("one rate needs a place theory", !(g.derive [groupsAlike]).contains samePlaceSameRate)
  , ("one rate needs alike groups", !(g.derive [elevation]).contains samePlaceSameRate)
  , ("one rate needs alike groups for miasma", !(g.derive [miasma]).contains samePlaceSameRate)
  , ("one rate needs alike groups for contact", !(g.derive [contact]).contains samePlaceSameRate)
  , ("water-borne cholera survives the companies",
      !g.refutes [waterborne, waterDiffers, groupsAlike, waterSupplyKnown] companies)
    -- the pump handle is not a clean test
  , ("the handle does not refute water-borne cholera", !g.refutes [waterborne, pumpPolluted] handleRemoval)
  , ("the handle does not refute miasma", !g.refutes [miasma, sameAir] handleRemoval)
  , ("the handle does not refute contact", !g.refutes [contact, noHiddenContact] handleRemoval)
  , ("no rival theory derives either reading of the handle",
      !(g.derive [waterborne, pumpPolluted, notFromPump, miasma, sameAir, contact, noHiddenContact]).contains
          fallBeforeHandle)
  ]

#guard (checks evidenceGraph).all (·.2)

end Scilib.JohnSnowAnd
