import Scilib.Basic

/-!
# 750 GeV diphoton excess (2015-16): fluctuation or new particle?

Domain #6 (search and selection effects).  Source facts and their verification:
`parth/sources/750-gev-diphoton-excess-2015-16/` (ledger.json, REPORT.md).  Primary sources:
ATLAS, JHEP 09 (2016) 001 (arXiv:1606.03833); CMS, PRL 117 (2016) 051802 (arXiv:1606.04093);
CMS, arXiv:1609.02507; ATLAS, PLB 775 (2017) 105 (arXiv:1707.04147); the ATLAS physics briefing on
the first 2016 results.

Graph shape (as in `MeselsonStahl.lean`):

* rivals: `backgroundFluctuation`, `spin0Resonance`, `spin2Graviton`.  The two resonance rivals both
  imply the shared claim `newParticleExists`, which contradicts `backgroundFluctuation`, so whatever
  excludes the claim excludes both of them; they also contradict each other (one spin each);
* observations: six `Experiment`s (ATLAS and CMS 2015, the ATLAS
  reanalysis of the 2015 data, and the 2016 data of CMS and ATLAS), each with its `interprets` edge;
* predictions: `entails [rival, assumptions] predictedReading`, and a `contradicts` edge between a
  predicted and an observed reading is what lets `refutes` fire;
* hidden assumptions: ordinary premises.  Their status (declared, suspected, discovered) lives only
  in `Theory.sources`, because the core has no `relies_on` edge.

The point of the example: a local significance of 3.9 sigma is a statement about one place in the
search range.  The global significance (about 2 sigma) counts the whole search range, and the 2015
data alone refute no rival.  Only the larger 2016 data separate them.
-/

namespace Scilib.GevDiphotonExcess

/-! ## Claims shared between the rivals -/

def newParticleExists : Theory :=
  { statement := "Hypothesis: the diphoton excess near 750 GeV is due to a new particle or resonance." }

/-! ## Rivals -/

def backgroundFluctuation : Theory :=
  { statement := "Statistical fluctuation: the 2015 excess near 750 GeV is a chance upward fluctuation of the Standard Model background and no new particle exists."
    sources := ["ATLAS physics briefing 2016", "Physics World 2016"] }

def spin0Resonance : Theory :=
  { statement := "Spin-0 resonance: a spin-0 resonance that decays to two photons, as predicted in theories with an extended Higgs sector."
    sources := ["ATLAS 2016 (JHEP 09 (2016) 001), spin-0 search", "Strumia 2016 (review)"] }

def spin2Graviton : Theory :=
  { statement := "Spin-2 resonance: a spin-2 resonance that decays to two photons, with the Randall-Sundrum graviton as the benchmark model."
    sources := ["ATLAS 2016 (JHEP 09 (2016) 001), spin-2 search", "Strumia 2016 (review)"] }

/-! ## Hidden assumptions (status recorded in `sources`) -/

def backgroundShapeAdequate : Theory :=
  { statement := "The Standard Model background in the diphoton mass spectrum is described by a smooth function fitted to the data."
    sources := ["status: declared", "ATLAS 2016 (JHEP 09 (2016) 001), spin-0 search", "CMS 2016 (PRL 117 051802), bias term"] }

def widthWithinScan : Theory :=
  { statement := "The search assumes that the width of the signal is at most 10 per cent of its mass."
    sources := ["status: declared", "ATLAS 2016 (JHEP 09 (2016) 001)", "CMS 2016 (PRL 117 051802): 3.4 sigma narrow, 2.3 sigma wide"] }

def luminosityKnown : Theory :=
  { statement := "The integrated luminosity of the 2015 data has an uncertainty of about 5 per cent."
    sources := ["status: declared", "ATLAS 2016 (JHEP 09 (2016) 001)"] }

def photonCalibrationCorrect : Theory :=
  { statement := "The 2015 photon reconstruction and energy calibration are correct near 750 GeV."
    sources := ["status: discovered (a later ATLAS reanalysis of the same data with improved calibration finds a smaller deviation)",
                "ATLAS 2017 (PLB 775 105)"] }

def sameRateIn2016 : Theory :=
  { statement := "A real resonance would be produced at the same rate in the 2016 data as in the 2015 data at 13 TeV."
    sources := ["status: suspected (not stated in the papers)"] }

def searchRangeCounted : Theory :=
  { statement := "The global significance counts every mass and width hypothesis scanned in the search (the look-elsewhere correction)."
    sources := ["status: declared", "ATLAS 2016 (JHEP 09 (2016) 001)", "CMS 2016 (PRL 117 051802)"] }

def gravitonCouplesUniversally : Theory :=
  { statement := "A spin-2 graviton couples universally to the conserved energy-momentum tensor, so it would also give a lepton-pair peak as large as the photon-pair peak."
    sources := ["status: declared", "Strumia 2016 (review)"] }

/-! ## Readings of the observations -/

def atlasLocalExcess : Theory :=
  { statement := "ATLAS 2015 data show a local excess near 750 GeV of 3.9 standard deviations in the spin-0 search and 3.8 in the spin-2 search, for a width of about 50 GeV."
    sources := ["ATLAS 2016 (JHEP 09 (2016) 001)"] }

def atlasGlobalExcess : Theory :=
  { statement := "The ATLAS global significance of the 2015 excess is 2.1 standard deviations for both the spin-0 and the spin-2 search."
    sources := ["ATLAS 2016 (JHEP 09 (2016) 001)"] }

def cmsLocalExcess : Theory :=
  { statement := "CMS 8 and 13 TeV data show a modest excess near 750 GeV with a local significance of about 3.4 standard deviations."
    sources := ["CMS 2016 (PRL 117 051802)"] }

def cmsGlobalExcess : Theory :=
  { statement := "The CMS global significance of the 750 GeV excess, after counting all signal hypotheses, is about 1.6 standard deviations."
    sources := ["CMS 2016 (PRL 117 051802)"] }

def atlasReanalysisSmaller : Theory :=
  { statement := "In the ATLAS reanalysis of the 2015 data with new reconstruction and calibration the largest spin-0 deviation is 3.3 standard deviations at 736 GeV, against 3.9 at 750 GeV before."
    sources := ["ATLAS 2017 (PLB 775 105)"] }

def cmsNoExcess2016 : Theory :=
  { statement := "The CMS 2016 data show no excess in the proximity of 750 GeV."
    sources := ["CMS 2016 (arXiv:1609.02507)"] }

def atlasNoExcess2016 : Theory :=
  { statement := "The ATLAS 2016 data show no large excess near 750 GeV, and the 2015 and 2016 datasets are compatible with a signal only at the level of 2.7 standard deviations."
    sources := ["ATLAS physics briefing 2016"] }

def atlasNoExcessCombined : Theory :=
  { statement := "In the ATLAS 2016 data no excess is seen near 750 GeV; in the combined 2015 and 2016 data the largest spin-0 deviation is 2.6 standard deviations near 730 GeV and its global significance is null."
    sources := ["ATLAS 2017 (PLB 775 105)"] }

/-! ## What each rival predicts for the larger 2016 data (an inference by the graph author) -/

def fluctuationPrediction : Theory :=
  { statement := "If the 2015 excess was a background fluctuation, the larger 2016 data show no excess near 750 GeV."
    sources := ["inference by the graph author, not in the papers (unverified)"] }

def resonancePrediction : Theory :=
  { statement := "If a real resonance with the 2015 mass, width and rate exists, the larger 2016 data show an excess near 750 GeV."
    sources := ["inference by the graph author, not in the papers (unverified)"] }

def fluctuationConfirmedCms : Theory :=
  { statement := "The prediction of the fluctuation rival matches the CMS 2016 data." }

def fluctuationConfirmedAtlas : Theory :=
  { statement := "The prediction of the fluctuation rival matches the ATLAS 2016 data." }

/-! ## Further claims -/

def noPeakInOtherChannels : Theory :=
  { statement := "No resonance near 750 GeV has been seen in other final states such as ZZ, lepton pairs or dijets."
    sources := ["Franceschini et al 2016", "Strumia 2016 (review)"] }

def localSignificanceInsufficient : Theory :=
  { statement := "A local significance of 3.9 standard deviations near 750 GeV is not enough to claim a new particle, because the search scanned many mass and width hypotheses and the global significance is only about 2 standard deviations."
    sources := ["inference by the graph author"] }

def comparativeCriterion : Theory :=
  { statement := "Among these explanations, prefer the one that is not contradicted by the observations when each of the others is contradicted by at least one of them."
    sources := ["criterion stated by the graph author, as in MeselsonStahl.lean"] }

def fluctuationBestSupported : Theory :=
  { statement := "Among a statistical fluctuation, a spin-0 resonance and a spin-2 resonance, the statistical fluctuation is the best supported explanation of the 2015 excess near 750 GeV."
    sources := ["ATLAS physics briefing 2016", "Physics World 2016"] }

/-! ## Experiments (raw records) -/

def atlas2015Experiment : Experiment :=
  { protocol := "ATLAS searches the diphoton invariant mass spectrum of 3.2 fb-1 of 13 TeV proton-proton data from 2015, with a spin-0 and a spin-2 selection, fitting a smooth background and scanning mass and width."
    observation := "The largest deviation from the background-only fit is in a broad region near 750 GeV with a width of about 50 GeV: local significance 3.8 (spin-2 search) and 3.9 (spin-0 search) standard deviations; global significance 2.1 for both searches."
    sources := ["ATLAS 2016 (JHEP 09 (2016) 001)"] }

def cms2015Experiment : Experiment :=
  { protocol := "CMS searches the diphoton mass spectrum of 19.7 fb-1 of 8 TeV and 3.3 fb-1 of 13 TeV data for spin-0 and spin-2 resonances over several width hypotheses."
    observation := "A modest excess near 750 GeV with local significance about 3.4 standard deviations for a narrow width (2.3 for a wide one); global significance about 1.6 standard deviations."
    sources := ["CMS 2016 (PRL 117 051802)"] }

def atlasReanalysisExperiment : Experiment :=
  { protocol := "ATLAS reanalyses its 2015 data with improved photon reconstruction, selection and energy calibration."
    observation := "The largest spin-0 local deviation is 3.3 standard deviations at 736 GeV with relative width 8 per cent; the old reconstruction and calibration gave 3.9 standard deviations at 750 GeV with relative width 6 per cent."
    sources := ["ATLAS 2017 (PLB 775 105)"] }

def cms2016Experiment : Experiment :=
  { protocol := "CMS repeats the search on 12.9 fb-1 of 13 TeV data recorded in 2016 and combines it with its 2015 and 8 TeV data."
    observation := "No excess is observed in the proximity of 750 GeV in the 2016 data."
    sources := ["CMS 2016 (arXiv:1609.02507)"] }

def atlas2016Experiment : Experiment :=
  { protocol := "ATLAS repeats the diphoton search on its 2016 13 TeV data at the mass and width of the largest 2015 excess."
    observation := "No large excess is observed in the 2016 data; the compatibility of the 2015 and 2016 datasets for a signal with the 2015 mass and width is at the level of 2.7 standard deviations."
    sources := ["ATLAS physics briefing 2016"] }

def atlasCombinedExperiment : Experiment :=
  { protocol := "ATLAS analyses 36.7 fb-1 of 13 TeV data recorded in 2015 and 2016."
    observation := "No excess is seen in the 2016 data around 750 GeV. In the combined 2015 and 2016 data the largest spin-0 local deviation is 2.6 standard deviations near 730 GeV for a narrow width, and its global significance is null."
    sources := ["ATLAS 2017 (PLB 775 105)"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- the rivals, built from claims
        Edge.implies spin0Resonance newParticleExists
      , Edge.implies spin2Graviton newParticleExists
      , Edge.contradicts newParticleExists backgroundFluctuation
          "A fluctuation of the background means there is no new particle."
      , Edge.contradicts spin0Resonance spin2Graviton
          "One resonance cannot have both spin 0 and spin 2."
      -- observations and their readings
      , Edge.interprets atlasLocalExcess atlas2015Experiment
      , Edge.interprets atlasGlobalExcess atlas2015Experiment
      , Edge.interprets cmsLocalExcess cms2015Experiment
      , Edge.interprets cmsGlobalExcess cms2015Experiment
      , Edge.interprets atlasReanalysisSmaller atlasReanalysisExperiment
      , Edge.interprets cmsNoExcess2016 cms2016Experiment
      , Edge.interprets atlasNoExcess2016 atlas2016Experiment
      , Edge.interprets atlasNoExcessCombined atlasCombinedExperiment
      -- what the rivals predict for the larger 2016 data
      , Edge.entails [backgroundFluctuation, backgroundShapeAdequate] fluctuationPrediction
          "A fluctuation of a well-modelled background is not repeated in new data."
      , Edge.entails
          [newParticleExists, backgroundShapeAdequate, widthWithinScan, luminosityKnown,
            photonCalibrationCorrect, sameRateIn2016]
          resonancePrediction
          "Inference by the graph author: a real signal of the same rate shows up again in more data."
      , Edge.contradicts resonancePrediction cmsNoExcess2016
      , Edge.contradicts resonancePrediction atlasNoExcess2016
      , Edge.contradicts resonancePrediction atlasNoExcessCombined
      , Edge.entails [fluctuationPrediction, cmsNoExcess2016] fluctuationConfirmedCms
          "The predicted absence of an excess is the observed one."
      , Edge.entails [fluctuationPrediction, atlasNoExcess2016] fluctuationConfirmedAtlas
          "The predicted absence of an excess is the observed one."
      -- the spin-2 rival has a second, independent problem
      , Edge.nogood [spin2Graviton, gravitonCouplesUniversally, noPeakInOtherChannels]
          "A graviton with universal couplings would also decay to lepton pairs, and no such peak is seen."
      -- local versus global significance
      , Edge.entails [atlasLocalExcess, atlasGlobalExcess, searchRangeCounted] localSignificanceInsufficient
          "Counting the whole search range turns 3.9 standard deviations into 2.1."
      -- the verdict, with its criterion stated as a premise
      , Edge.entails
          [backgroundFluctuation, fluctuationConfirmedCms, fluctuationConfirmedAtlas,
            localSignificanceInsufficient, comparativeCriterion]
          fluctuationBestSupported
          "The explanation whose prediction matches the new data, while the other two are each contradicted, is the best supported."
      ] }

/-! ## Checks: what `lake build` verifies -/

def resonanceAssumptions : List Theory :=
  [backgroundShapeAdequate, widthWithinScan, luminosityKnown, photonCalibrationCorrect, sameRateIn2016]

def allObservations : List Theory :=
  [atlasLocalExcess, atlasGlobalExcess, cmsLocalExcess, cmsGlobalExcess, atlasReanalysisSmaller, cmsNoExcess2016, atlasNoExcess2016, atlasNoExcessCombined,
    backgroundShapeAdequate, widthWithinScan, luminosityKnown, photonCalibrationCorrect,
    sameRateIn2016, searchRangeCounted]

/-- The verdict counts only if the granted theories are consistent. -/
def verdictStands (g : Graph) (granted : List Theory) : Bool :=
  !g.inconsistent granted && (g.derive granted).contains fluctuationBestSupported

/-- `premises` derive `concl`, and removing any one of them loses it. -/
def minimallyJustified (g : Graph) (premises : List Theory) (concl : Theory) : Bool :=
  (g.derive premises).contains concl &&
    premises.all fun p => !(g.derive (premises.erase p)).contains concl

def checks (g : Graph) : List (String × Bool) :=
  [ -- the rivals are pairwise exclusive
    ("fluctuation excludes spin-0", g.exclusive backgroundFluctuation spin0Resonance)
  , ("fluctuation excludes spin-2", g.exclusive backgroundFluctuation spin2Graviton)
  , ("spin-0 excludes spin-2", g.exclusive spin0Resonance spin2Graviton)
    -- the 2015 data alone refute none of the rivals
  , ("2015 ATLAS spares fluctuation",
      !g.refutes (backgroundFluctuation :: resonanceAssumptions) atlas2015Experiment)
  , ("2015 ATLAS spares spin-0",
      !g.refutes (spin0Resonance :: resonanceAssumptions) atlas2015Experiment)
  , ("2015 CMS spares spin-0",
      !g.refutes (spin0Resonance :: resonanceAssumptions) cms2015Experiment)
    -- the larger 2016 data refute the new particle, whatever its spin
  , ("CMS 2016 refutes spin-0", g.refutes (spin0Resonance :: resonanceAssumptions) cms2016Experiment)
  , ("CMS 2016 refutes spin-2", g.refutes (spin2Graviton :: resonanceAssumptions) cms2016Experiment)
  , ("ATLAS 2016 refutes spin-0", g.refutes (spin0Resonance :: resonanceAssumptions) atlas2016Experiment)
  , ("ATLAS 2016 refutes spin-2", g.refutes (spin2Graviton :: resonanceAssumptions) atlas2016Experiment)
  , ("ATLAS combined refutes spin-0",
      g.refutes (spin0Resonance :: resonanceAssumptions) atlasCombinedExperiment)
  , ("2016 spares fluctuation",
      !g.refutes (backgroundFluctuation :: resonanceAssumptions) cms2016Experiment)
  , ("2016 ATLAS spares fluctuation",
      !g.refutes (backgroundFluctuation :: resonanceAssumptions) atlas2016Experiment)
  , ("fluctuation confirmed by CMS 2016",
      (g.derive (cmsNoExcess2016 :: backgroundFluctuation :: resonanceAssumptions)).contains
        fluctuationConfirmedCms)
  , ("a rival alone is not an observation",
      !(g.derive (backgroundFluctuation :: resonanceAssumptions)).contains cmsNoExcess2016)
    -- blame (Duhem-Quine): drop one hidden assumption and the refutation disappears
  , ("blame: refutation needs the same-rate assumption",
      !g.refutes [spin0Resonance, backgroundShapeAdequate, widthWithinScan, luminosityKnown,
        photonCalibrationCorrect] cms2016Experiment)
  , ("blame: refutation needs the background shape",
      !g.refutes [spin0Resonance, widthWithinScan, luminosityKnown, photonCalibrationCorrect,
        sameRateIn2016] cms2016Experiment)
  , ("blame: refutation needs the width assumption",
      !g.refutes [spin0Resonance, backgroundShapeAdequate, luminosityKnown, photonCalibrationCorrect,
        sameRateIn2016] cms2016Experiment)
  , ("blame: refutation needs the luminosity",
      !g.refutes [spin0Resonance, backgroundShapeAdequate, widthWithinScan, photonCalibrationCorrect,
        sameRateIn2016] cms2016Experiment)
  , ("blame: refutation needs the calibration",
      !g.refutes [spin0Resonance, backgroundShapeAdequate, widthWithinScan, luminosityKnown,
        sameRateIn2016] cms2016Experiment)
    -- the spin-2 rival is also excluded by the other channels, the spin-0 rival is not
  , ("other channels exclude universal graviton",
      g.inconsistent [spin2Graviton, gravitonCouplesUniversally, noPeakInOtherChannels])
  , ("graviton exclusion needs the universal coupling",
      !g.inconsistent [spin2Graviton, noPeakInOtherChannels])
  , ("graviton exclusion needs the null result in other channels",
      !g.inconsistent [spin2Graviton, gravitonCouplesUniversally])
  , ("other channels spare spin-0",
      !g.inconsistent [spin0Resonance, gravitonCouplesUniversally, noPeakInOtherChannels])
    -- all the evidence together: only the fluctuation survives
  , ("all evidence spares fluctuation", !g.inconsistent (backgroundFluctuation :: allObservations))
  , ("all evidence refutes spin-0",
      g.inconsistent (spin0Resonance :: allObservations))
  , ("all evidence refutes spin-2",
      g.inconsistent (spin2Graviton :: allObservations))
    -- the verdict stands for the fluctuation only, and only with its criterion granted
  , ("verdict stands for fluctuation",
      verdictStands g (backgroundFluctuation :: comparativeCriterion :: allObservations))
  , ("verdict fails for spin-0",
      !verdictStands g (spin0Resonance :: comparativeCriterion :: allObservations))
  , ("verdict fails for spin-2",
      !verdictStands g (spin2Graviton :: comparativeCriterion :: allObservations))
  , ("verdict needs its criterion", !verdictStands g (backgroundFluctuation :: allObservations))
    -- the local excess alone is derived as insufficient only with the search range counted
  , ("local significance is insufficient",
      (g.derive [atlasLocalExcess, atlasGlobalExcess, searchRangeCounted]).contains
        localSignificanceInsufficient)
  , ("insufficiency needs the search range",
      !(g.derive [atlasLocalExcess, atlasGlobalExcess]).contains localSignificanceInsufficient)
  , ("graph is well formed", g.wellFormed)
    -- each prediction needs exactly the rival and its assumptions
  , ("fluctuation prediction",
      minimallyJustified g [backgroundFluctuation, backgroundShapeAdequate] fluctuationPrediction)
  , ("resonance prediction",
      minimallyJustified g (newParticleExists :: resonanceAssumptions) resonancePrediction)
  , ("fluctuation confirmed (CMS)",
      minimallyJustified g [fluctuationPrediction, cmsNoExcess2016] fluctuationConfirmedCms)
  , ("fluctuation confirmed (ATLAS)",
      minimallyJustified g [fluctuationPrediction, atlasNoExcess2016] fluctuationConfirmedAtlas)
  , ("local significance insufficient needs exactly its premises",
      minimallyJustified g [atlasLocalExcess, atlasGlobalExcess, searchRangeCounted]
        localSignificanceInsufficient)
  , ("the verdict needs exactly its premises",
      minimallyJustified g
        [backgroundFluctuation, fluctuationConfirmedCms, fluctuationConfirmedAtlas,
          localSignificanceInsufficient, comparativeCriterion]
        fluctuationBestSupported)
    -- every reading is attached to its experiment
  , ("ATLAS 2015 local reading", g.readings.contains (atlasLocalExcess, atlas2015Experiment))
  , ("ATLAS 2015 global reading", g.readings.contains (atlasGlobalExcess, atlas2015Experiment))
  , ("CMS 2015 local reading", g.readings.contains (cmsLocalExcess, cms2015Experiment))
  , ("CMS 2015 global reading", g.readings.contains (cmsGlobalExcess, cms2015Experiment))
  , ("reanalysis reading", g.readings.contains (atlasReanalysisSmaller, atlasReanalysisExperiment))
  , ("CMS 2016 reading", g.readings.contains (cmsNoExcess2016, cms2016Experiment))
  , ("ATLAS 2016 reading", g.readings.contains (atlasNoExcess2016, atlas2016Experiment))
  , ("ATLAS combined reading", g.readings.contains (atlasNoExcessCombined, atlasCombinedExperiment))
  ]

#guard (checks evidenceGraph).all (·.2)

end Scilib.GevDiphotonExcess
