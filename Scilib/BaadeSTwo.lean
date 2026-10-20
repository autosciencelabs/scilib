import Scilib.Basic

/-!
# Baade's two Cepheid populations (1952): one period-luminosity law or two?

Domain #4 (hidden assumption in the measurement).  Source facts and their verification:
`parth/sources/baade-s-two-cepheid-populations-1952/` (ledger.json, REPORT.md).  Primary sources:
W. Baade, "The period-luminosity relation of the Cepheids", PASP 68, 5 (1956; the lecture that
reports the 1952 Rome talk), and W. Baade, ApJ 100, 137 (1944).  Secondary sources: AIP history of
cosmology, Huchra's history of the Hubble constant, Allen's history of the Cepheid scale, Kragh's
historical lectures, Livio's review, Wikipedia.

Graph shape (as in `MeselsonStahl.lean` and `GevDiphotonExcess.lean`):

* rivals: `oneLaw` (one period-luminosity relation for all cepheids and cluster-type variables, the
  hidden assumption inside every Cepheid distance) and `twoLaws` (one relation for each stellar
  population); they contradict each other;
* observations: four `Experiment`s, each with its `interprets` edge: the 200-inch plates of the
  Andromeda nebula, the resolved globular clusters there, the globular clusters of Hubble 1931,
  and the Small Magellanic Cloud cluster NGC 121 (reported by Baade);
* predictions: `entails [oneLaw, assumptions] oneLawPrediction`, and a `nogood` between a prediction
  and an observed reading is what lets `refutes` fire;
* hidden assumptions: ordinary premises.  Their status (declared, suspected, discovered) lives only
  in `Theory.sources`, because the core has no `relies_on` edge;
* consequence: with the zero point set by the cluster-type variables, every distance based on type I
  cepheids is doubled, the Hubble constant is halved and the "universe younger than the Earth"
  conflict eases.

The point of the example: the 1931 mismatch of the globular clusters alone could not say which
assumption was wrong (the single law, or the sameness of the clusters).  Only the 200-inch
plates, which do not use the clusters, blame the single law.
-/

namespace Scilib.BaadeSTwo

/-! ## Rivals -/

def oneLaw : Theory :=
  { statement := "One period-luminosity relation: a single period-luminosity relation covers the whole range of the cepheid variation, the cluster-type variables included."
    sources := ["Baade 1956 (PASP 68, 5)", "AIP history of cosmology"] }

def twoLaws : Theory :=
  { statement := "Two period-luminosity relations: instead of one relation there are two, one for type I cepheids and one for type II, and on average a type I cepheid is 1.5 magnitudes brighter than a type II cepheid of the same period."
    sources := ["Baade 1956 (PASP 68, 5)", "Allen, The Cepheid Distance Scale"] }

/-! ## Hidden assumptions (status recorded in `sources`) -/

def clusterVariableMagnitudeZero : Theory :=
  { statement := "The mean absolute photographic magnitude of the cluster-type variables is about 0.0 (+0.08 ± 0.15 from the proper motions of 58 of them)."
    sources := ["Baade 1956 (PASP 68, 5)"] }

def absorptionAccountedFor : Theory :=
  { statement := "The interstellar absorption of the type I cepheids is correctly taken into account in their absolute magnitude, which is the more uncertain of the two zero points."
    sources := ["status: discovered", "Baade 1956 (PASP 68, 5)"] }

def magnitudeScaleAdequate : Theory :=
  { statement := "The provisional system of magnitudes set up in the Andromeda nebula is adequate for the faint stars measured there."
    sources := ["status: discovered", "Baade 1956 (PASP 68, 5)"] }

def smcMagnitudeScaleAdequate : Theory :=
  { statement := "The magnitude scale used for the faint cluster-type variables in the Magellanic Clouds is accurate."
    sources := ["status: discovered", "Baade 1956 (PASP 68, 5)"] }

def clustersAlike : Theory :=
  { statement := "The globular clusters of the Andromeda nebula and of our own galaxy do not really differ in their upper limit of luminosity."
    sources := ["status: declared", "Baade 1956 (PASP 68, 5)"] }

def distanceMethodsDiffer : Theory :=
  { statement := "The distance of the Andromeda nebula was determined by type I cepheids, whereas the distances of the globular clusters in our own galaxy were based on type II cepheids, the cluster-type variables."
    sources := ["Baade 1956 (PASP 68, 5)"] }

def zeroPointTrusted : Theory :=
  { statement := "The absolute magnitude of the cluster-type variables is the best choice for the zero point of the period-luminosity relations, and the determinations of the absolute magnitudes of the type I cepheids are disregarded."
    sources := ["status: declared", "Baade 1956 (PASP 68, 5)"] }

/-! ## Readings of the experiments -/

def popIIAtLimit : Theory :=
  { statement := "In the Andromeda nebula the brightest stars of population II, not the cluster-type variables, appeared at about the limiting magnitude of the plates."
    sources := ["Baade 1956 (PASP 68, 5)"] }

def popIIBrightestSameAsClusters : Theory :=
  { statement := "The brightest stars of population II in the Andromeda nebula have the same absolute magnitude, Mpg = -1.5, as the brightest stars in globular clusters."
    sources := ["Baade 1956 (PASP 68, 5)"] }

def globularGap : Theory :=
  { statement := "The upper limit of luminosity of the globular clusters of the Andromeda nebula is about 1.5 magnitudes fainter than that of the globular clusters of our own galaxy."
    sources := ["Baade 1956 (PASP 68, 5), reporting Hubble 1931"] }

def smcVariablesFainter : Theory :=
  { statement := "The cluster-type variables in the globular cluster NGC 121 of the Small Magellanic Cloud have apparent magnitudes close to 19."
    sources := ["Baade 1956 (PASP 68, 5), reporting Thackeray and Wesselink"] }

/-! ## What the rivals predict -/

def oneLawPrediction : Theory :=
  { statement := "If the accepted period-luminosity relation held, the cluster-type variables of the Andromeda nebula would appear at the limiting magnitude of the plates."
    sources := ["Baade 1956 (PASP 68, 5)"] }

def popIIBrighterThanVariables : Theory :=
  { statement := "The brightest stars of population II are photographically 1.5 magnitudes brighter than the cluster-type variables."
    sources := ["Baade 1956 (PASP 68, 5)"] }

def smcOneLawPrediction : Theory :=
  { statement := "According to the old period-luminosity relation the cluster-type variables in NGC 121 were expected at apparent magnitude 17.3."
    sources := ["Baade 1956 (PASP 68, 5)"] }

/-! ## Consequences for the distance scale and the age of the universe -/

def distancesDoubled : Theory :=
  { statement := "The distances derived previously from type I cepheids have to be multiplied by the factor 2."
    sources := ["Baade 1956 (PASP 68, 5)", "AIP history of cosmology"] }

def velocityDistance : Theory :=
  { statement := "Velocity-distance relation: the recessional velocity of a galaxy increases with its distance."
    sources := ["Wikipedia, Edwin Hubble", "Livio, The Hubble constant"] }

def h0Is500 : Theory :=
  { statement := "With Hubble's distances the expansion rate was approximately 500 km/s/Mpc."
    sources := ["Huchra, The Hubble constant", "Livio, The Hubble constant", "Wikipedia, Hubble's law"] }

def backCalculation : Theory :=
  { statement := "The age of the universe is estimated by calculating back to when all the galaxies started moving apart from the measured velocities."
    sources := ["AIP history of cosmology", "Wikipedia, Age of the universe"] }

def expansionAgeShort : Theory :=
  { statement := "The expansion age of the universe inferred from Hubble's value was only about 2 billion years."
    sources := ["Huchra, The Hubble constant", "AIP history of cosmology", "Kragh, Historical aspects of post-1850 cosmology"] }

def earthAgeThreeGyr : Theory :=
  { statement := "Radioactive dating of rocks had shown geologists that the Earth was about 3 billion years old."
    sources := ["Huchra, The Hubble constant", "AIP history of cosmology", "Wikipedia, Age of Earth"] }

def universeNotYoungerThanEarth : Theory :=
  { statement := "The universe cannot be younger than the Earth."
    sources := ["AIP history of cosmology", "Kragh, Historical aspects of post-1850 cosmology"] }

def h0Halved : Theory :=
  { statement := "Doubling the distances while the velocities stay the same halves the expansion rate, so the Hubble constant falls by about a factor of two."
    sources := ["Livio, The Hubble constant"] }

def ageConflictEased : Theory :=
  { statement := "With the Hubble constant halved the Hubble time becomes at least 3.6 billion years, longer than the 3 billion years of the Earth then accepted."
    sources := ["Kragh, Historical aspects of post-1850 cosmology"] }

/-! ## Experiments -/

def andromedaPlatesExperiment : Experiment :=
  { protocol := "Photographs of three selected variable-star fields in the Andromeda nebula with the 200-inch telescope, started in the early fall of 1950."
    observation := "The brightest stars of the population II appeared at about the limiting magnitude of the plates."
    sources := ["Baade 1956 (PASP 68, 5)"] }

def andromedaClustersExperiment : Experiment :=
  { protocol := "Exposures of fields of the Andromeda nebula with the 200-inch telescope on photovisual and red-sensitive plates."
    observation := "Whenever the exposure time for a given field was sufficient to bring out the brightest stars of population II, the outer parts of any globular clusters in the field showed resolution into stars."
    sources := ["Baade 1956 (PASP 68, 5)"] }

def hubble1931Experiment : Experiment :=
  { protocol := "Hubble's 1931 investigation of the globular clusters of the Andromeda nebula, compared with those of our own galaxy."
    observation := "The upper limit of luminosity of the globular clusters of the Andromeda nebula was about 1.5 magnitudes fainter than the upper limit of the globular clusters of our own galaxy."
    sources := ["Baade 1956 (PASP 68, 5), reporting Hubble 1931"] }

def smcClusterExperiment : Experiment :=
  { protocol := "Search for cluster-type variables in the globular cluster NGC 121 of the Small Magellanic Cloud (Thackeray and Wesselink, as reported by Baade)."
    observation := "The first cluster-type variables found in NGC 121 had apparent magnitudes close to 19."
    sources := ["Baade 1956 (PASP 68, 5), reporting Thackeray and Wesselink"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ Edge.contradicts oneLaw twoLaws
          "One relation for every cepheid cannot also be two different relations."
      -- observations and their readings
      , Edge.interprets popIIAtLimit andromedaPlatesExperiment
      , Edge.interprets popIIBrightestSameAsClusters andromedaClustersExperiment
      , Edge.interprets globularGap hubble1931Experiment
      , Edge.interprets smcVariablesFainter smcClusterExperiment
      -- what the single law predicts
      , Edge.entails
          [oneLaw, clusterVariableMagnitudeZero, absorptionAccountedFor, magnitudeScaleAdequate]
          oneLawPrediction
          "The distance modulus of the Andromeda nebula comes from type I cepheids; the single law carries it over to the cluster-type variables."
      , Edge.entails [popIIBrightestSameAsClusters, clusterVariableMagnitudeZero]
          popIIBrighterThanVariables
          "Mpg = -1.5 against Mpg = 0.0 is a difference of 1.5 magnitudes."
      , Edge.nogood [oneLawPrediction, popIIAtLimit, popIIBrighterThanVariables]
          "The cluster-type variables cannot be at the limit if the brightest population II stars, 1.5 magnitudes brighter, are the ones found there."
      , Edge.entails
          [oneLaw, clusterVariableMagnitudeZero, absorptionAccountedFor, smcMagnitudeScaleAdequate]
          smcOneLawPrediction
          "The single law places the cluster-type variables of NGC 121 at magnitude 17.3."
      , Edge.contradicts smcOneLawPrediction smcVariablesFainter
          "17.3 expected, close to 19 found."
      , Edge.nogood [oneLaw, clustersAlike, globularGap]
          "With one law both galaxies' cluster distances are on the same scale, so clusters that are alike reach the same upper luminosity."
      -- what the two laws predict
      , Edge.entails [twoLaws, popIIBrighterThanVariables] popIIAtLimit
          "Inference by the graph author: type II variables 1.5 magnitudes fainter than the old relation puts them lie below the limit where the brightest population II stars sit."
      , Edge.entails [twoLaws, distanceMethodsDiffer] globularGap
          "Distances from type I and type II cepheids differ by 1.5 magnitudes."
      , Edge.entails [twoLaws, clusterVariableMagnitudeZero] smcVariablesFainter
          "Type II variables about 1.5 magnitudes fainter than the old relation puts them."
      -- consequence for the distance scale and the age of the universe
      , Edge.entails [twoLaws, zeroPointTrusted] distancesDoubled
          "A type I cepheid 1.5 magnitudes brighter than thought is 2 times farther away."
      , Edge.entails [oneLaw, h0Is500, backCalculation] expansionAgeShort
          "If Hubble's distances are right (the single law), 500 km/s/Mpc calculated back gives about 2 billion years."
      , Edge.nogood [expansionAgeShort, earthAgeThreeGyr, universeNotYoungerThanEarth]
          "An expansion age of about 2 billion years is shorter than the 3 billion years of the Earth."
      , Edge.entails [distancesDoubled, h0Is500, velocityDistance] h0Halved
          "Same velocities, twice the distances."
      , Edge.entails [h0Halved, backCalculation, earthAgeThreeGyr] ageConflictEased
          "The Hubble time doubles to more than the Earth's age then accepted."
      ] }

/-! ## Checks: what `lake build` verifies -/

/-- The assumptions every Andromeda-plate prediction needs. -/
def plateAssumptions : List Theory :=
  [clusterVariableMagnitudeZero, absorptionAccountedFor, magnitudeScaleAdequate,
    popIIBrightestSameAsClusters]

def smcAssumptions : List Theory :=
  [clusterVariableMagnitudeZero, absorptionAccountedFor, smcMagnitudeScaleAdequate]

def allObservations : List Theory :=
  [popIIAtLimit, popIIBrightestSameAsClusters, globularGap, smcVariablesFainter,
    clusterVariableMagnitudeZero, absorptionAccountedFor, magnitudeScaleAdequate,
    smcMagnitudeScaleAdequate, clustersAlike, distanceMethodsDiffer]

/-- Named checks; the verifier mutates the graph and runs these on every mutant. -/
def checks (g : Graph) : List (String × Bool) :=
  [ ("graph is well formed", g.wellFormed)
    -- the rivals exclude each other
  , ("one law excludes two laws", g.exclusive oneLaw twoLaws)
    -- the 200-inch plates refute the single law and spare the two laws
  , ("plates refute one law", g.refutes (oneLaw :: plateAssumptions) andromedaPlatesExperiment)
  , ("plates spare two laws", !g.refutes (twoLaws :: plateAssumptions) andromedaPlatesExperiment)
  , ("two laws explain the plates", g.supports (twoLaws :: plateAssumptions) andromedaPlatesExperiment)
  , ("one law does not explain the plates",
      !g.supports (oneLaw :: plateAssumptions) andromedaPlatesExperiment)
    -- blame: drop one hidden assumption and the refutation disappears
  , ("blame: refutation needs the cluster-variable magnitude",
      !g.refutes [oneLaw, absorptionAccountedFor, magnitudeScaleAdequate,
        popIIBrightestSameAsClusters] andromedaPlatesExperiment)
  , ("blame: refutation needs the absorption correction",
      !g.refutes [oneLaw, clusterVariableMagnitudeZero, magnitudeScaleAdequate,
        popIIBrightestSameAsClusters] andromedaPlatesExperiment)
  , ("blame: refutation needs the magnitude scale",
      !g.refutes [oneLaw, clusterVariableMagnitudeZero, absorptionAccountedFor,
        popIIBrightestSameAsClusters] andromedaPlatesExperiment)
  , ("blame: refutation needs the cluster resolution",
      !g.refutes [oneLaw, clusterVariableMagnitudeZero, absorptionAccountedFor,
        magnitudeScaleAdequate] andromedaPlatesExperiment)
  , ("blame: refutation needs the single law",
      !g.refutes [clusterVariableMagnitudeZero, absorptionAccountedFor, magnitudeScaleAdequate,
        popIIBrightestSameAsClusters] andromedaPlatesExperiment)
  , ("the prediction itself needs the cluster-variable magnitude",
      !g.refutes [oneLaw, absorptionAccountedFor, magnitudeScaleAdequate,
        popIIBrighterThanVariables] andromedaPlatesExperiment)
  , ("the cluster resolution alone does not give the 1.5 magnitudes",
      !(g.derive [popIIBrightestSameAsClusters]).contains popIIBrighterThanVariables)
    -- the resolved clusters alone refute nothing
  , ("cluster resolution spares one law",
      !g.refutes (oneLaw :: plateAssumptions) andromedaClustersExperiment)
  , ("cluster resolution spares two laws",
      !g.refutes (twoLaws :: plateAssumptions) andromedaClustersExperiment)
    -- the Magellanic Cloud cluster confirms it independently
  , ("NGC 121 refutes one law", g.refutes (oneLaw :: smcAssumptions) smcClusterExperiment)
  , ("NGC 121 spares two laws", !g.refutes (twoLaws :: smcAssumptions) smcClusterExperiment)
  , ("two laws explain NGC 121", g.supports (twoLaws :: smcAssumptions) smcClusterExperiment)
  , ("blame: NGC 121 needs the magnitude scale",
      !g.refutes [oneLaw, clusterVariableMagnitudeZero, absorptionAccountedFor]
        smcClusterExperiment)
  , ("blame: NGC 121 needs the absorption correction",
      !g.refutes [oneLaw, clusterVariableMagnitudeZero, smcMagnitudeScaleAdequate]
        smcClusterExperiment)
  , ("blame: NGC 121 needs the cluster-variable magnitude",
      !g.refutes [oneLaw, absorptionAccountedFor, smcMagnitudeScaleAdequate] smcClusterExperiment)
  , ("blame: NGC 121 needs the single law",
      !g.refutes [clusterVariableMagnitudeZero, absorptionAccountedFor, smcMagnitudeScaleAdequate]
        smcClusterExperiment)
  , ("one law alone does not explain NGC 121", !g.supports [oneLaw] smcClusterExperiment)
  , ("two laws alone do not explain NGC 121", !g.supports [twoLaws] smcClusterExperiment)
  , ("the cluster-variable magnitude alone does not explain NGC 121",
      !g.supports [clusterVariableMagnitudeZero] smcClusterExperiment)
    -- the 1931 mismatch cannot say which assumption is wrong
  , ("1931 refutes one law only together with alike clusters",
      g.refutes [oneLaw, clustersAlike] hubble1931Experiment)
  , ("1931 alone spares one law", !g.refutes [oneLaw] hubble1931Experiment)
  , ("1931 alone spares alike clusters", !g.refutes [clustersAlike] hubble1931Experiment)
  , ("1931 spares two laws with alike clusters",
      !g.refutes [twoLaws, clustersAlike, distanceMethodsDiffer] hubble1931Experiment)
  , ("two laws explain 1931",
      g.supports [twoLaws, distanceMethodsDiffer] hubble1931Experiment)
  , ("the method difference alone does not explain 1931",
      !g.supports [distanceMethodsDiffer] hubble1931Experiment)
  , ("2 laws without the method difference do not explain 1931",
      !g.supports [twoLaws] hubble1931Experiment)
    -- the consequence for distances
  , ("two laws double the distances", (g.derive [twoLaws, zeroPointTrusted]).contains distancesDoubled)
  , ("doubling needs the zero point choice",
      !(g.derive [twoLaws]).contains distancesDoubled)
  , ("doubling needs the two laws", !(g.derive [zeroPointTrusted]).contains distancesDoubled)
    -- the age conflict under the single law
  , ("single law gives a short age",
      (g.derive [oneLaw, h0Is500, backCalculation]).contains expansionAgeShort)
  , ("the short age needs the single law", !(g.derive [h0Is500, backCalculation]).contains expansionAgeShort)
  , ("the short age needs the 500 value", !(g.derive [oneLaw, backCalculation]).contains expansionAgeShort)
  , ("the short age needs the back-calculation", !(g.derive [oneLaw, h0Is500]).contains expansionAgeShort)
  , ("single law with the Earth's age is inconsistent",
      g.inconsistent [oneLaw, h0Is500, backCalculation, earthAgeThreeGyr, universeNotYoungerThanEarth])
  , ("age conflict needs the single law",
      !g.inconsistent [h0Is500, backCalculation, earthAgeThreeGyr, universeNotYoungerThanEarth])
  , ("age conflict needs the 500 value",
      !g.inconsistent [oneLaw, backCalculation, earthAgeThreeGyr, universeNotYoungerThanEarth])
  , ("age conflict needs the back-calculation",
      !g.inconsistent [oneLaw, h0Is500, earthAgeThreeGyr, universeNotYoungerThanEarth])
  , ("age conflict needs the Earth's age",
      !g.inconsistent [oneLaw, h0Is500, backCalculation, universeNotYoungerThanEarth])
  , ("age conflict needs the principle",
      !g.inconsistent [oneLaw, h0Is500, backCalculation, earthAgeThreeGyr])
  , ("two laws with doubling remove the conflict",
      !g.inconsistent [twoLaws, zeroPointTrusted, h0Is500, velocityDistance, backCalculation,
        earthAgeThreeGyr, universeNotYoungerThanEarth])
  , ("doubling halves the Hubble constant",
      (g.derive [twoLaws, zeroPointTrusted, h0Is500, velocityDistance]).contains h0Halved)
  , ("halving needs the doubling", !(g.derive [h0Is500, velocityDistance]).contains h0Halved)
  , ("halving needs the 500 value",
      !(g.derive [twoLaws, zeroPointTrusted, velocityDistance]).contains h0Halved)
  , ("halving needs the velocity-distance relation",
      !(g.derive [twoLaws, zeroPointTrusted, h0Is500]).contains h0Halved)
  , ("the conflict eases", (g.derive [twoLaws, zeroPointTrusted, h0Is500, velocityDistance,
      backCalculation, earthAgeThreeGyr]).contains ageConflictEased)
  , ("easing needs the halving", !(g.derive [h0Is500, velocityDistance, backCalculation,
      earthAgeThreeGyr]).contains ageConflictEased)
  , ("easing needs the back-calculation", !(g.derive [twoLaws, zeroPointTrusted, h0Is500, velocityDistance,
      earthAgeThreeGyr]).contains ageConflictEased)
  , ("easing needs the Earth's age", !(g.derive [twoLaws, zeroPointTrusted, h0Is500, velocityDistance,
      backCalculation]).contains ageConflictEased)
    -- a rival alone is not an observation
  , ("a rival alone is not an observation", !(g.derive [twoLaws]).contains popIIAtLimit)
    -- readings
  , ("plates reading", g.readings.contains (popIIAtLimit, andromedaPlatesExperiment))
  , ("cluster resolution reading",
      g.readings.contains (popIIBrightestSameAsClusters, andromedaClustersExperiment))
  , ("1931 reading", g.readings.contains (globularGap, hubble1931Experiment))
  , ("NGC 121 reading", g.readings.contains (smcVariablesFainter, smcClusterExperiment))
  ]

#guard (checks evidenceGraph).all (·.2)

end Scilib.BaadeSTwo
