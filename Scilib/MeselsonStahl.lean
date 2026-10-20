import Scilib.Basic

/-!
# Meselson-Stahl 1958: which model of DNA replication survives?

Domain #2 (crucial test between rivals).  Source facts and their verification status:
`parth/sources/meselson-stahl-1958.md`.  Primary source: M. Meselson and F. W. Stahl,
PNAS 44(7), 671-682, 1958 (read in full).

Graph shape (the Earth-graph layers, as far as the core allows):

* rivals: `conservativeModel`, `semiconservativeModel`, `dispersiveModel`.  Each is built from
  shared claims with `entails [claims] model`, and entails its claims back, so a contradiction
  between two claims is inherited by the rivals that contain them;
* observations: six `Experiment`s read off the paper's figures, each with its `interprets` edge;
* predictions: `entails [rival, assumptions] predictedReading`, and a `contradicts` edge between a
  predicted and an observed reading is what lets `refutes` fire;
* hidden assumptions: ordinary premises.  Their status (declared, suspected, discovered) lives only
  in `Theory.sources`, because the core has no `relies_on` edge.  This is the main gap this file shows.

Two points where the paper differs from the textbook retelling (see the source sheet):
the paper rules out Delbruck's dispersive scheme with the heat-denaturation experiment, not with
generation 2; and it does not claim to show that the subunits are single polynucleotide chains.
-/

namespace Scilib.MeselsonStahl

/-! ## Claims shared between the rivals -/

def parentalSubunitsIntact : Theory :=
  { statement := "The two parental subunits of a DNA molecule remain intact through replication." }

def parentalMaterialFragmented : Theory :=
  { statement := "Parental DNA material is broken up and dispersed among the new material of both daughter molecules."
    sources := ["Delbruck's scheme, Meselson and Stahl 1958, p. 681, ref. 24"] }

def parentalSubunitsStayTogether : Theory :=
  { statement := "Both parental subunits go to the same daughter molecule." }

def eachDaughterGetsOneParentalSubunit : Theory :=
  { statement := "Each daughter molecule receives exactly one parental subunit."
    sources := ["Meselson and Stahl 1958, p. 676, conclusion 2"] }

/-! ## Rivals (names from Delbruck and Stent 1957, not opened: unverified) -/

def conservativeModel : Theory :=
  { statement := "Conservative replication: the parental duplex stays intact and the daughter duplex is entirely new."
    sources := ["Delbruck and Stent 1957 (unverified)"] }

def semiconservativeModel : Theory :=
  { statement := "Semiconservative replication (Watson-Crick): the parental strands separate and each daughter keeps one."
    sources := ["Meselson and Stahl 1958, p. 677", "Watson and Crick 1953 (unverified)"] }

def dispersiveModel : Theory :=
  { statement := "Dispersive replication: parental material is fragmented and interspersed with new material in both daughters."
    sources := ["Delbruck 1955, as cited in Meselson and Stahl 1958, p. 681"] }

/-! ## Hidden assumptions (status recorded in `sources`) -/

def bandPositionGivesLabelFraction : Theory :=
  { statement := "The position of a DNA band between the fully labeled and unlabeled bands gives its fraction of 15N label."
    sources := ["status: declared", "Meselson and Stahl 1958, p. 676 (error about 2 per cent)"] }

def labelDoesNotChangeReplication : Theory :=
  { statement := "Labeling the DNA with 15N does not change how it replicates."
    sources := ["status: suspected (not stated in the paper)"] }

def generationTimeUniform : Theory :=
  { statement := "The generation time is nearly the same for all DNA molecules in the population."
    sources := ["status: declared", "Meselson and Stahl 1958, footnote 14"] }

def apparentMolecularWeightReliable : Theory :=
  { statement := "Apparent molecular weights from density-gradient banding are reliable, with no uncorrected solvation error."
    sources := ["status: discovered (footnote 12 reports a source of error not discussed earlier)",
                "Meselson and Stahl 1958, footnote 12"] }

/-! ## Readings of the observations -/

def gen1HalfLabeledOnly : Theory :=
  { statement := "One generation after the shift to 14N, all DNA forms a single half-labeled band, with no fully labeled or unlabeled band."
    sources := ["Meselson and Stahl 1958, p. 676, Fig. 4"] }

def gen2HalfAndUnlabeledEqual : Theory :=
  { statement := "Two generations after the shift to 14N, DNA forms a half-labeled band and an unlabeled band in equal amounts."
    sources := ["Meselson and Stahl 1958, p. 676, Fig. 4"] }

def hybridBandHalfway : Theory :=
  { statement := "In a mixture of generation 0 and generation 1.9 DNA, the intermediate band lies at 50 +/- 2 per cent of the distance between the unlabeled and fully labeled bands."
    sources := ["Meselson and Stahl 1958, Fig. 4 caption"] }

def heatedHybridTwoSpecies : Theory :=
  { statement := "Heated half-labeled DNA gives two density species in equal amounts, each with about half the initial apparent molecular weight."
    sources := ["Meselson and Stahl 1958, p. 681, Fig. 9B"] }

def heatedMixtureResemblesHybrid : Theory :=
  { statement := "A mixture of heated 15N DNA and heated 14N DNA gives two bands closely resembling those from heated half-labeled DNA."
    sources := ["Meselson and Stahl 1958, p. 681, Fig. 9C"] }

def salmonKeepsWeightWhenHeated : Theory :=
  { statement := "Heated salmon-sperm DNA becomes denser but keeps its apparent molecular weight."
    sources := ["Meselson and Stahl 1958, pp. 679-681"] }

/-! ## What each rival predicts (an inference by the graph author where marked) -/

def conservativeGen1Prediction : Theory :=
  { statement := "One generation after the shift to 14N, the DNA forms a fully labeled band and an unlabeled band and no half-labeled band." }

def conservativeGen2Prediction : Theory :=
  { statement := "Two generations after the shift to 14N, the DNA forms a fully labeled band and an unlabeled band and no half-labeled band." }

def dispersiveGen2Prediction : Theory :=
  { statement := "Two generations after the shift to 14N, all DNA forms a single band at about a quarter of the fully labeled position."
    sources := ["inference by the graph author, not in the paper (unverified)"] }

/-! The semiconservative and dispersive predictions at generation 1, and the semiconservative one at
generation 2, are separate nodes from the observed readings.  Using the same node for "predicted"
and "observed" would let the model derive the observation by itself, so a verdict built on it would
not depend on the observation having been made.  A `Confirmed` node needs both. -/

def semiGen1Prediction : Theory :=
  { statement := "The semiconservative model predicts that one generation after the shift to 14N all DNA forms a single half-labeled band." }

def semiGen2Prediction : Theory :=
  { statement := "The semiconservative model predicts that two generations after the shift to 14N DNA forms a half-labeled band and an unlabeled band in equal amounts." }

def dispersiveGen1Prediction : Theory :=
  { statement := "The dispersive model predicts that one generation after the shift to 14N all DNA forms a single half-labeled band." }

def semiGen1Confirmed : Theory :=
  { statement := "The semiconservative prediction for generation 1 matches the observed band pattern." }

def semiGen2Confirmed : Theory :=
  { statement := "The semiconservative prediction for generation 2 matches the observed band pattern." }

def dispersiveGen1Confirmed : Theory :=
  { statement := "The dispersive prediction for generation 1 matches the observed band pattern." }

/-! ## Conclusions drawn from the observations -/

def subunitsDissociateByHeat : Theory :=
  { statement := "Heating dissociates the two subunits of a half-labeled DNA molecule."
    sources := ["Meselson and Stahl 1958, p. 681"] }

def subunitsAreContinuousStructures : Theory :=
  { statement := "The subunits that are conserved at duplication are single, continuous structures."
    sources := ["Meselson and Stahl 1958, p. 681"] }

def comparativeCriterion : Theory :=
  { statement := "Among these three stated models, prefer the one that is not contradicted by the observations when each of the others is contradicted by at least one of them."
    sources := ["criterion stated by the graph author, as in Heliocentrism.lean"] }

def semiconservativeBestSupported : Theory :=
  { statement := "Among conservative, semiconservative and dispersive replication, the semiconservative model is the best supported by the 1958 observations."
    sources := ["Meselson and Stahl 1958, p. 678: 'in exact accord with the expectations of the Watson-Crick model'; the paper does not claim the subunits are single chains"] }

def salmonSubunitsBoundTighter : Theory :=
  { statement := "One interpretation offered by the authors: salmon-sperm DNA has subunits like E. coli DNA, bound together more tightly."
    sources := ["Meselson and Stahl 1958, p. 681"] }

def salmonHasNoSubunits : Theory :=
  { statement := "The other interpretation offered by the authors: salmon-sperm DNA has no such subunits, so E. coli DNA is the more complex structure."
    sources := ["Meselson and Stahl 1958, p. 681"] }

/-! ## Experiments (raw records) -/

def gen1Experiment : Experiment :=
  { protocol := "Grow E. coli for 14 generations in 15N medium, shift to a tenfold excess of 14N, and take DNA one generation later; centrifuge in CsCl (1.71 g/cm3, 140,000 g, 20 h) and scan the bands."
    observation := "Fully labeled DNA is depleted; only half-labeled molecules are present."
    sources := ["Meselson and Stahl 1958, p. 676, Fig. 4"] }

def gen2Experiment : Experiment :=
  { protocol := "Same culture, DNA taken two generation times after the shift to 14N."
    observation := "Half-labeled and unlabeled DNA are present in equal amounts."
    sources := ["Meselson and Stahl 1958, p. 676, Fig. 4"] }

def mixedControlExperiment : Experiment :=
  { protocol := "Mix DNA from generation 0 and from generation 1.9 and centrifuge the mixture in CsCl."
    observation := "Three peaks; after allowing for their relative amounts the intermediate peak sits at 50 +/- 2 per cent of the distance between the N14 and N15 peaks."
    sources := ["Meselson and Stahl 1958, Fig. 4 caption"] }

def heatedHybridExperiment : Experiment :=
  { protocol := "Heat a detergent lysate of half-labeled DNA at 100 C for 30 minutes in the CsCl medium and centrifuge."
    observation := "The half-labeled band disappears; two new bands of equal amount appear, 0.015 g/cm3 apart, each with about half the initial apparent molecular weight."
    sources := ["Meselson and Stahl 1958, p. 681, Fig. 9B"] }

def heatedMixtureExperiment : Experiment :=
  { protocol := "Heat 15N DNA and 14N DNA separately, mix them, and centrifuge in CsCl."
    observation := "The mixture of heated 15N and heated 14N DNA differs in density by 0.015 g/cm3 and closely resembles the products from heated half-labeled DNA."
    sources := ["Meselson and Stahl 1958, p. 681, Fig. 9C"] }

def salmonExperiment : Experiment :=
  { protocol := "Heat purified salmon-sperm DNA at 100 C for 30 minutes in CsCl and measure density and apparent molecular weight."
    observation := "Density rises by 0.014 g/cm3 with no change in apparent molecular weight."
    sources := ["Meselson and Stahl 1958, pp. 679-681"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- the rivals, built from claims and entailing them back
        Edge.entails [parentalSubunitsIntact, parentalSubunitsStayTogether] conservativeModel
          "The conservative model is made of these two claims."
      , Edge.implies conservativeModel parentalSubunitsIntact
      , Edge.implies conservativeModel parentalSubunitsStayTogether
      , Edge.entails [parentalSubunitsIntact, eachDaughterGetsOneParentalSubunit] semiconservativeModel
          "The semiconservative model is made of these two claims."
      , Edge.implies semiconservativeModel parentalSubunitsIntact
      , Edge.implies semiconservativeModel eachDaughterGetsOneParentalSubunit
      , Edge.implies parentalMaterialFragmented dispersiveModel
      , Edge.implies dispersiveModel parentalMaterialFragmented
      , Edge.contradicts parentalSubunitsStayTogether eachDaughterGetsOneParentalSubunit
          "Both parental subunits cannot go to one daughter while each daughter gets exactly one."
      , Edge.contradicts parentalSubunitsIntact parentalMaterialFragmented
          "Intact parental subunits and fragmented parental material are incompatible."
      -- observations and their readings
      , Edge.interprets gen1HalfLabeledOnly gen1Experiment
      , Edge.interprets gen2HalfAndUnlabeledEqual gen2Experiment
      , Edge.interprets hybridBandHalfway mixedControlExperiment
      , Edge.interprets heatedHybridTwoSpecies heatedHybridExperiment
      , Edge.interprets heatedMixtureResemblesHybrid heatedMixtureExperiment
      , Edge.interprets salmonKeepsWeightWhenHeated salmonExperiment
      -- predictions at generation 1
      , Edge.entails
          [conservativeModel, bandPositionGivesLabelFraction, labelDoesNotChangeReplication,
            generationTimeUniform, hybridBandHalfway]
          conservativeGen1Prediction
          "Intact parental duplexes would give fully labeled and unlabeled bands."
      , Edge.contradicts conservativeGen1Prediction gen1HalfLabeledOnly
      , Edge.entails
          [semiconservativeModel, bandPositionGivesLabelFraction, labelDoesNotChangeReplication,
            generationTimeUniform, hybridBandHalfway]
          semiGen1Prediction
          "Every daughter holds one parental and one new strand, so all DNA is half-labeled."
      , Edge.entails [semiGen1Prediction, gen1HalfLabeledOnly] semiGen1Confirmed
          "The predicted band pattern is the observed one."
      , Edge.entails
          [dispersiveModel, bandPositionGivesLabelFraction, labelDoesNotChangeReplication,
            generationTimeUniform, hybridBandHalfway]
          dispersiveGen1Prediction
          "Parental material spread evenly also leaves every molecule half-labeled, so generation 1 cannot separate these two."
      , Edge.entails [dispersiveGen1Prediction, gen1HalfLabeledOnly] dispersiveGen1Confirmed
          "The predicted band pattern is the observed one."
      -- predictions at generation 2
      , Edge.entails
          [conservativeModel, bandPositionGivesLabelFraction, labelDoesNotChangeReplication,
            generationTimeUniform, hybridBandHalfway]
          conservativeGen2Prediction
      , Edge.contradicts conservativeGen2Prediction gen2HalfAndUnlabeledEqual
      , Edge.entails
          [semiconservativeModel, bandPositionGivesLabelFraction, labelDoesNotChangeReplication,
            generationTimeUniform, hybridBandHalfway]
          semiGen2Prediction
          "Half of the generation 2 molecules keep a parental strand, half hold only new strands."
      , Edge.entails [semiGen2Prediction, gen2HalfAndUnlabeledEqual] semiGen2Confirmed
          "The predicted band pattern is the observed one."
      , Edge.entails
          [dispersiveModel, bandPositionGivesLabelFraction, labelDoesNotChangeReplication,
            generationTimeUniform, hybridBandHalfway]
          dispersiveGen2Prediction
          "Inference by the graph author: dilution gives one band at a quarter of the label."
      , Edge.contradicts dispersiveGen2Prediction gen2HalfAndUnlabeledEqual
      -- the paper's own chain for heat denaturation (this is what rules out Delbruck's scheme)
      , Edge.entails [heatedHybridTwoSpecies, heatedMixtureResemblesHybrid] subunitsDissociateByHeat
          "The heated hybrid behaves like heated 15N DNA mixed with heated 14N DNA."
      , Edge.entails [subunitsDissociateByHeat, heatedHybridTwoSpecies, apparentMolecularWeightReliable]
          subunitsAreContinuousStructures
          "Halves of the apparent molecular weight mean the subunits are single, continuous structures."
      , Edge.contradicts subunitsAreContinuousStructures parentalMaterialFragmented
          "Continuous conserved subunits cannot be fragmented parental material."
      -- the paper's conclusion 2, from generations 1 and 2 together
      , Edge.entails
          [gen1HalfLabeledOnly, gen2HalfAndUnlabeledEqual, bandPositionGivesLabelFraction,
            labelDoesNotChangeReplication, generationTimeUniform, hybridBandHalfway]
          eachDaughterGetsOneParentalSubunit
          "Meselson and Stahl's conclusion 2."
      -- the verdict, with its criterion stated as a premise
      , Edge.entails
          [semiconservativeModel, semiGen1Confirmed, semiGen2Confirmed,
            subunitsAreContinuousStructures, comparativeCriterion]
          semiconservativeBestSupported
          "The model whose predictions match every observation, while the other two are each contradicted, is the best supported."
      -- the open anomaly: one record, two rival readings
      , Edge.interprets salmonSubunitsBoundTighter salmonExperiment
      , Edge.interprets salmonHasNoSubunits salmonExperiment
      , Edge.contradicts salmonSubunitsBoundTighter salmonHasNoSubunits
      ] }

/-! ## Checks: what `lake build` verifies -/

def baseAssumptions : List Theory :=
  [bandPositionGivesLabelFraction, labelDoesNotChangeReplication, generationTimeUniform,
    hybridBandHalfway]

def heatAssumptions : List Theory :=
  [apparentMolecularWeightReliable, heatedMixtureResemblesHybrid]

def allObservations : List Theory :=
  [gen1HalfLabeledOnly, gen2HalfAndUnlabeledEqual, hybridBandHalfway, heatedHybridTwoSpecies,
    heatedMixtureResemblesHybrid, apparentMolecularWeightReliable,
    bandPositionGivesLabelFraction, labelDoesNotChangeReplication, generationTimeUniform]

/-- The verdict counts only if the granted theories are consistent.  Without this check an
inconsistent set (for example the conservative model plus all the observations) would still derive
the verdict, because the evidence also supplies the semiconservative model's two claims. -/
def verdictStands (g : Graph) (granted : List Theory) : Bool :=
  !g.inconsistent granted && (g.derive granted).contains semiconservativeBestSupported

/-- `premises` derive `concl`, and removing any one of them loses it: the justification is minimal.
This pins down each edge's intended premise set, so dropping or adding a premise is detected. -/
def minimallyJustified (g : Graph) (premises : List Theory) (concl : Theory) : Bool :=
  (g.derive premises).contains concl &&
    premises.all fun p => !(g.derive (premises.erase p)).contains concl

/-- Every check as a named result, so the mutation runner can re-evaluate them on altered graphs.
`lake build` verifies that all of them hold on `evidenceGraph` (the `#guard` below). -/
def checks (g : Graph) : List (String × Bool) :=
  [ -- the rivals are pairwise exclusive
    ("conservative excludes semiconservative", g.exclusive conservativeModel semiconservativeModel)
  , ("conservative excludes dispersive", g.exclusive conservativeModel dispersiveModel)
  , ("semiconservative excludes dispersive", g.exclusive semiconservativeModel dispersiveModel)
    -- generation 1 kills conservative only; it cannot separate semiconservative from dispersive
  , ("gen1 refutes conservative", g.refutes (conservativeModel :: baseAssumptions) gen1Experiment)
  , ("gen1 spares semiconservative", !g.refutes (semiconservativeModel :: baseAssumptions) gen1Experiment)
  , ("gen1 spares dispersive", !g.refutes (dispersiveModel :: baseAssumptions) gen1Experiment)
  , ("gen1 confirms semiconservative",
      (g.derive (gen1HalfLabeledOnly :: semiconservativeModel :: baseAssumptions)).contains
        semiGen1Confirmed)
  , ("gen1 confirms dispersive",
      (g.derive (gen1HalfLabeledOnly :: dispersiveModel :: baseAssumptions)).contains
        dispersiveGen1Confirmed)
  , ("gen2 confirms semiconservative",
      (g.derive (gen2HalfAndUnlabeledEqual :: semiconservativeModel :: baseAssumptions)).contains
        semiGen2Confirmed)
  , ("a model alone is not an observation",
      !(g.derive (semiconservativeModel :: baseAssumptions)).contains gen1HalfLabeledOnly)
    -- generation 2 separates dispersive from semiconservative (the dispersive prediction is an inference)
  , ("gen2 refutes dispersive", g.refutes (dispersiveModel :: baseAssumptions) gen2Experiment)
  , ("gen2 refutes conservative", g.refutes (conservativeModel :: baseAssumptions) gen2Experiment)
  , ("gen2 spares semiconservative", !g.refutes (semiconservativeModel :: baseAssumptions) gen2Experiment)
    -- the paper's own route: heat denaturation rules out the dispersive scheme
  , ("heat refutes dispersive", g.refutes (dispersiveModel :: heatAssumptions) heatedHybridExperiment)
  , ("heat spares semiconservative", !g.refutes (semiconservativeModel :: heatAssumptions) heatedHybridExperiment)
    -- blame (Duhem-Quine): drop one hidden assumption and the refutation disappears
  , ("blame: gen1 needs the band-position assumption",
      !g.refutes [conservativeModel, labelDoesNotChangeReplication, generationTimeUniform, hybridBandHalfway]
        gen1Experiment)
  , ("blame: heat needs the molecular-weight assumption",
      !g.refutes [dispersiveModel, heatedMixtureResemblesHybrid] heatedHybridExperiment)
    -- all the evidence together: only the semiconservative model survives
  , ("all evidence spares semiconservative", !g.inconsistent (semiconservativeModel :: allObservations))
  , ("all evidence refutes conservative", g.inconsistent (conservativeModel :: allObservations))
  , ("all evidence refutes dispersive", g.inconsistent (dispersiveModel :: allObservations))
    -- the verdict stands for the semiconservative model only, and only with its criterion granted
  , ("verdict stands for semiconservative",
      verdictStands g (semiconservativeModel :: comparativeCriterion :: allObservations))
  , ("verdict fails for conservative",
      !verdictStands g (conservativeModel :: comparativeCriterion :: allObservations))
  , ("verdict fails for dispersive",
      !verdictStands g (dispersiveModel :: comparativeCriterion :: allObservations))
  , ("verdict needs its criterion", !verdictStands g (semiconservativeModel :: allObservations))
    -- the continuity of the subunits is derived; that they are single polynucleotide chains is not
    -- claimed by the paper (p. 678) and has no node here
  , ("subunits are continuous structures",
      (g.derive allObservations).contains subunitsAreContinuousStructures)
    -- the salmon-sperm record has two incompatible readings and the graph keeps both
  , ("salmon readings are exclusive", g.exclusive salmonSubunitsBoundTighter salmonHasNoSubunits)
  , ("graph is well formed", g.wellFormed)
    -- each rival is exactly its claims
  , ("conservative = intact + stay together",
      minimallyJustified g [parentalSubunitsIntact, parentalSubunitsStayTogether] conservativeModel)
  , ("semiconservative = intact + one subunit each",
      minimallyJustified g [parentalSubunitsIntact, eachDaughterGetsOneParentalSubunit]
        semiconservativeModel)
  , ("dispersive = fragmented material",
      minimallyJustified g [parentalMaterialFragmented] dispersiveModel)
    -- each prediction needs exactly the model and the four assumptions
  , ("conservative gen1 prediction",
      minimallyJustified g (conservativeModel :: baseAssumptions) conservativeGen1Prediction)
  , ("semiconservative gen1 prediction",
      minimallyJustified g (semiconservativeModel :: baseAssumptions) semiGen1Prediction)
  , ("dispersive gen1 prediction",
      minimallyJustified g (dispersiveModel :: baseAssumptions) dispersiveGen1Prediction)
  , ("semiconservative gen1 confirmed",
      minimallyJustified g [semiGen1Prediction, gen1HalfLabeledOnly] semiGen1Confirmed)
  , ("dispersive gen1 confirmed",
      minimallyJustified g [dispersiveGen1Prediction, gen1HalfLabeledOnly] dispersiveGen1Confirmed)
  , ("semiconservative gen2 confirmed",
      minimallyJustified g [semiGen2Prediction, gen2HalfAndUnlabeledEqual] semiGen2Confirmed)
  , ("conservative gen2 prediction",
      minimallyJustified g (conservativeModel :: baseAssumptions) conservativeGen2Prediction)
  , ("semiconservative gen2 prediction",
      minimallyJustified g (semiconservativeModel :: baseAssumptions) semiGen2Prediction)
  , ("dispersive gen2 prediction",
      minimallyJustified g (dispersiveModel :: baseAssumptions) dispersiveGen2Prediction)
    -- the heat chain and the paper's conclusion 2
  , ("heat dissociates subunits",
      minimallyJustified g [heatedHybridTwoSpecies, heatedMixtureResemblesHybrid]
        subunitsDissociateByHeat)
  , ("subunits are continuous",
      minimallyJustified g
        [subunitsDissociateByHeat, heatedHybridTwoSpecies, apparentMolecularWeightReliable]
        subunitsAreContinuousStructures)
  , ("conclusion 2: each daughter gets one subunit",
      minimallyJustified g
        ([gen1HalfLabeledOnly, gen2HalfAndUnlabeledEqual] ++ baseAssumptions)
        eachDaughterGetsOneParentalSubunit)
  , ("the verdict needs exactly its premises",
      minimallyJustified g
        [semiconservativeModel, semiGen1Confirmed, semiGen2Confirmed,
          subunitsAreContinuousStructures, comparativeCriterion]
        semiconservativeBestSupported)
    -- every reading is attached to its experiment
  , ("gen1 reading", g.readings.contains (gen1HalfLabeledOnly, gen1Experiment))
  , ("gen2 reading", g.readings.contains (gen2HalfAndUnlabeledEqual, gen2Experiment))
  , ("mixed-control reading", g.readings.contains (hybridBandHalfway, mixedControlExperiment))
  , ("heated hybrid reading", g.readings.contains (heatedHybridTwoSpecies, heatedHybridExperiment))
  , ("heated mixture reading",
      g.readings.contains (heatedMixtureResemblesHybrid, heatedMixtureExperiment))
  , ("salmon reading", g.readings.contains (salmonKeepsWeightWhenHeated, salmonExperiment))
  , ("salmon reading: tighter binding",
      g.readings.contains (salmonSubunitsBoundTighter, salmonExperiment))
  , ("salmon reading: no subunits", g.readings.contains (salmonHasNoSubunits, salmonExperiment))
  ]

#guard (checks evidenceGraph).all (·.2)

end Scilib.MeselsonStahl
