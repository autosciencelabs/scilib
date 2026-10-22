import Scilib.Basic

namespace Scilib.Superconductivity


/-! ## Theories -/


def perfectConduction : Theory where
 statement := "A metal can enter a state of zero electrical resistance where current persists indefinitely without a driving electric field."
 sources := ["Onnes, 1911"]


def londonTheory : Theory where
 statement := "Superconductivity is described by macroscopic Maxwell modifications yielding magnetic field expulsion and a characteristic penetration depth."
 sources := ["F. and H. London, 1935"]


def bcsTheory : Theory where
 statement := "Electrons near the Fermi surface form bound pairs (Cooper pairs) mediated by virtual phonon exchanges, creating an electronic energy gap."
 sources := ["Bardeen, Cooper, and Schrieffer, 1957"]


def electronPhononCoupling : Theory where
 statement := "The superconducting transition temperature depends inversely on the isotopic mass of the constituent lattice ions."
 sources := ["Fröhlich, 1950; Maxwell / Reynolds et al., 1950"]


/-! ## Limiting Regimes -/


def lowFieldLimit : Theory :=
 { statement := "The applied magnetic field is far below the material's critical magnetic field." }


def lowTempLimit : Theory :=
 { statement := "The operating temperature is far below the superconducting transition temperature T_c." }


/-! ## Assumptions -/


def pureSample : Theory :=
 { statement := "The metallic sample has negligible chemical impurities and lattice defects." }


def fieldCoolingEquilibrium : Theory :=
 { statement := "Magnetic flux expulsion is measured under true thermodynamic equilibrium rather than being trapped by pinning centers." }


def isotopicPurity : Theory :=
 { statement := "The tested samples consist of a single isolated isotope species with well-defined atomic mass." }


def standardCalorimetricSeparation : Theory :=
 { statement := "The electronic and lattice specific heat contributions can be cleanly separated across the transition." }


/-! ## Claims -/


def vanishingResistivity : Theory :=
 { statement := "The electrical resistance drops to an unmeasurable value below a sharp transition temperature T_c." }


def magneticFluxExpulsion : Theory :=
 { statement := "Magnetic induction B vanishes entirely inside the bulk superconductor regardless of cooling history." }


def electronicEnergyGap : Theory :=
 { statement := "There is a minimum energy threshold of 2Δ to break a Cooper pair, causing exponential freeze-out of electronic specific heat at low T." }


def inverseSquareRootMassDependence : Theory :=
 { statement := "The critical transition temperature is proportional to M to the power of negative one half, where M is isotopic mass." }


def specificHeatJump : Theory :=
 { statement := "The electronic specific heat exhibits a finite thermodynamic discontinuity (jump) at T_c." }


/-! ## Predictions -/


def onnesResistanceDropPrediction : Theory :=
 { statement := "The measured electrical resistance of solid mercury vanishes abruptly when cooled below approximately 4.2 K." }


def meissnerExpulsionPrediction : Theory :=
 { statement := "A superconducting sample cooled in a magnetic field expels the flux entirely, acting as a complete diamagnet." }


def bcsExponentialHeatCapacityPrediction : Theory :=
 { statement := "The electronic specific heat drops exponentially at temperatures well below T_c due to the superconducting energy gap." }


def isotopeShiftPrediction : Theory :=
 { statement := "Different stable isotopes of the same metallic element exhibit distinctly shifted critical temperatures scaling with atomic weight." }


/-! ## Raw Experiments -/


def onnes1911 : Experiment where
 protocol := "Measure the electrical resistance of solid mercury inside a liquid helium cryostat down to 4.2 K and below."
 observation := "At 4.2 K the resistance suddenly drops to virtually zero."
 sources := ["Onnes, Communications from the Physical Laboratory of the University of Leiden, 1911"]


def meissner1933 : Experiment where
 protocol := "Cool tin and lead single crystals in a weak applied magnetic field and map the external and internal magnetic flux distribution."
 observation := "The magnetic induction inside the bulk metal drops to zero upon passing T_c, demonstrating active flux expulsion."
 sources := ["Meissner and Ochsenfeld, Naturwissenschaften, 1933"]


def corak1954 : Experiment where
 protocol := "Measure the low-temperature specific heat of superconducting vanadium or tin down to sub-kelvin ranges."
 observation := "The specific heat falls off exponentially, deviating strongly from the normal metal linear electronic term."
 sources := ["Corak et al., Physical Review, 1954"]


def isotopeEffect1950 : Experiment where
 protocol := "Synthesize pure superconducting samples using distinct separated mercury or isotope fractions and measure T_c precisely."
 observation := "Transition temperature varies systematically with isotopic mass."
 sources := ["Maxwell, 1950; Reynolds et al., 1950"]


/-! ## The Graph -/


def evidenceGraph : Graph where
 edges := [
   Edge.implies perfectConduction vanishingResistivity,
   Edge.implies londonTheory magneticFluxExpulsion,
   Edge.implies londonTheory vanishingResistivity,
   Edge.implies bcsTheory vanishingResistivity,
   Edge.implies bcsTheory magneticFluxExpulsion,
   Edge.implies bcsTheory electronicEnergyGap,
   Edge.implies bcsTheory specificHeatJump,
   Edge.implies electronPhononCoupling inverseSquareRootMassDependence,


   Edge.entails [vanishingResistivity, pureSample] onnesResistanceDropPrediction
     "relies_on: high sample purity so residual resistance does not mask the transition.",
   Edge.interprets onnesResistanceDropPrediction onnes1911
     "Resistance vanishing below liquid helium temperatures.",


   Edge.entails [magneticFluxExpulsion, lowFieldLimit, fieldCoolingEquilibrium] meissnerExpulsionPrediction
     "relies_on: low fields and true thermodynamic equilibrium to avoid flux pinning artifacts.",
   Edge.interprets meissnerExpulsionPrediction meissner1933
     "Complete expulsion of magnetic induction from the bulk interior.",


   Edge.entails [electronicEnergyGap, lowTempLimit, standardCalorimetricSeparation] bcsExponentialHeatCapacityPrediction
     "relies_on: clean separation of lattice vibrations from electronic excitations.",
   Edge.interprets bcsExponentialHeatCapacityPrediction corak1954
     "Exponential drop in specific heat characteristic of pair-breaking energy gaps.",


   Edge.entails [inverseSquareRootMassDependence, isotopicPurity] isotopeShiftPrediction
     "relies_on: pure isotope fractions to isolate atomic mass dependence.",
   Edge.interprets isotopeShiftPrediction isotopeEffect1950
     "Systematic variation of T_c with isotopic mass fractions."
 ]


/-! ## Analysis -/


def experiments : List (String × Experiment) :=
 [ ("Onnes1911", onnes1911),
   ("Meissner1933", meissner1933),
   ("Corak1954", corak1954),
   ("IsotopeEffect1950", isotopeEffect1950) ]


def verdict (world : List Theory) (e : Experiment) : String :=
 if evidenceGraph.refutes world e then "refuted"
 else if evidenceGraph.supports world e then "supported"
 else "silent"


def scoreboard (world : List Theory) : List (String × String) :=
 experiments.map fun p => (p.1, verdict world p.2)


def refutedBy (world : List Theory) : List String :=
 experiments.filterMap fun p =>
   if evidenceGraph.refutes world p.2 then some p.1 else none


def reliesOn (reading : Theory) : List (List String) :=
 (evidenceGraph.justifications reading).map fun ps => ps.map (·.statement)


def commonAux : List Theory :=
 [ pureSample, fieldCoolingEquilibrium, isotopicPurity, lowFieldLimit, lowTempLimit, standardCalorimetricSeparation ]


def worldPureResistanceOnly : List Theory :=
 [perfectConduction] ++ commonAux


def worldLondonPhenomenological : List Theory :=
 [perfectConduction, londonTheory] ++ commonAux


def worldBcsFullTheory : List Theory :=
 [bcsTheory, electronPhononCoupling] ++ commonAux


#eval scoreboard worldPureResistanceOnly
#eval scoreboard worldLondonPhenomenological
#eval scoreboard worldBcsFullTheory
#eval reliesOn onnesResistanceDropPrediction


/-! ## Checks -/


#guard evidenceGraph.wellFormed


#guard (evidenceGraph.derive [bcsTheory, lowTempLimit]).contains electronicEnergyGap
#guard (evidenceGraph.derive [electronPhononCoupling]).contains inverseSquareRootMassDependence


#guard evidenceGraph.supports [perfectConduction, pureSample] onnes1911
#guard evidenceGraph.supports [bcsTheory, pureSample] onnes1911


#guard evidenceGraph.supports [londonTheory, lowFieldLimit, fieldCoolingEquilibrium] meissner1933
#guard evidenceGraph.supports [bcsTheory, lowFieldLimit, fieldCoolingEquilibrium] meissner1933
#guard !evidenceGraph.supports [perfectConduction, lowFieldLimit, fieldCoolingEquilibrium] meissner1933


#guard evidenceGraph.supports [bcsTheory, lowTempLimit, standardCalorimetricSeparation] corak1954
#guard !evidenceGraph.supports [perfectConduction, lowTempLimit, standardCalorimetricSeparation] corak1954


#guard evidenceGraph.supports [electronPhononCoupling, isotopicPurity] isotopeEffect1950


#guard refutedBy worldPureResistanceOnly == []
#guard refutedBy worldLondonPhenomenological == []
#guard refutedBy worldBcsFullTheory == []


end Scilib.Superconductivity




/-! ## RECENT EXTENSION: nickelate thin films and LK-99
 Nickelate: ambient-pressure films with onset Tc above 40 K, zero resistance and
 Meissner diamagnetism (SUSTech, Nature). LK-99: apparent levitation traced to
 ferromagnetic Cu2S, not Meissner expulsion (secondary source).
 unconventionalPairing is MY hypothesis, not a claim from those sources. -/


namespace Scilib.Superconductivity.Recent


def phononTcCap : Theory where
 statement := "A purely phonon-mediated superconductor at ambient pressure has T_c no higher than roughly 40 K (McMillan-type limit)."
 sources := ["McMillan, Phys. Rev., 1968 (heuristic limit, not a theorem)"]


def unconventionalPairing : Theory :=
 { statement := "Pairing in the nickelate is mediated by a non-phonon channel (e.g. magnetic or orbital fluctuations), so its T_c is not bounded by the phonon-mediated cap." }


def lk99Claim : Theory where
 statement := "LK-99 is an ambient-pressure, near-room-temperature superconductor."
 sources := ["LK-99 preprints, 2023"]


def phononOnlyModerateCoupling : Theory :=
 { statement := "The pairing glue in the sample is entirely electron-phonon with moderate coupling strength." }


def interfaceStrainEnhancement : Theory :=
 { statement := "Interfacial strain and heterostructure doping in ultrathin films raise the pairing strength." }


def tcAboveCapObs : Theory :=
 { statement := "Ambient-pressure nickelate films show onset T_c above 40 K with zero resistance and Meissner diamagnetism." }


def lk99Expulsion : Theory :=
 { statement := "Bulk LK-99 expels magnetic flux (Meissner effect)." }


def lk99FerromagneticObs : Theory :=
 { statement := "Apparent LK-99 levitation is ferromagnetism of a Cu2S impurity phase, with no bulk flux expulsion." }


def sustechNickelate : Experiment where
 protocol := "Measure transport and magnetic response of strain-engineered, atomic-layer-by-layer epitaxial nickelate films about 3 unit cells thick, at ambient pressure."
 observation := "Onset T_c above 40 K with coexisting zero resistance and Meissner diamagnetism."
 sources := ["SUSTech team, Nature (ambient-pressure nickelate films), per SUSTech news release"]


def lk99Replication : Experiment where
 protocol := "Examine LK-99 samples for zero resistance and bulk flux expulsion."
 observation := "Apparent levitation is ferromagnetic behaviour from Cu2S, not the Meissner effect."
 sources := ["PatSnap, Room-temperature superconductor research 2026 landscape (secondary source)"]


def extendedGraph : Graph where
 edges := evidenceGraph.edges ++ [
   Edge.implies unconventionalPairing vanishingResistivity,


   Edge.entails [bcsTheory, phononOnlyModerateCoupling] phononTcCap
     "relies_on: phonon-only glue at moderate coupling; the auxiliary assumption most exposed to refutation.",
   Edge.contradicts phononTcCap tcAboveCapObs
     "A phonon-only superconductor cannot exceed the cap, yet T_c above 40 K was observed.",
   Edge.entails [unconventionalPairing, interfaceStrainEnhancement] tcAboveCapObs
     "relies_on: a non-phonon channel plus strain-enhanced pairing in ultrathin films.",
   Edge.interprets tcAboveCapObs sustechNickelate
     "Onset T_c above 40 K with zero resistance and diamagnetism.",


   Edge.implies lk99Claim lk99Expulsion,
   Edge.contradicts lk99Expulsion lk99FerromagneticObs
     "Ferromagnetic levitation is incompatible with true flux expulsion.",
   Edge.interprets lk99FerromagneticObs lk99Replication
     "Levitation traced to Cu2S ferromagnetism."
 ]


def allExperiments : List (String × Experiment) :=
 experiments ++ [("SustechNickelate", sustechNickelate), ("LK99Replication", lk99Replication)]


def verdictX (world : List Theory) (e : Experiment) : String :=
 if extendedGraph.refutes world e then "refuted"
 else if extendedGraph.supports world e then "supported"
 else "silent"


def scoreboardX (world : List Theory) : List (String × String) :=
 allExperiments.map fun p => (p.1, verdictX world p.2)


def refutedByX (world : List Theory) : List String :=
 allExperiments.filterMap fun p =>
   if extendedGraph.refutes world p.2 then some p.1 else none


def reliesOnX (reading : Theory) : List (List String) :=
 (extendedGraph.justifications reading).map fun ps => ps.map (·.statement)


def worldBcsPhononOnly : List Theory :=
 [bcsTheory, electronPhononCoupling, phononOnlyModerateCoupling] ++ commonAux


def worldBcsNoGlueAssumption : List Theory :=
 [bcsTheory, electronPhononCoupling] ++ commonAux


def worldUnconventional : List Theory :=
 [unconventionalPairing, interfaceStrainEnhancement] ++ commonAux


def worldLk99 : List Theory :=
 [lk99Claim] ++ commonAux


def worldMixed : List Theory :=
 worldBcsPhononOnly ++ [unconventionalPairing, interfaceStrainEnhancement]


#eval scoreboardX worldBcsPhononOnly
#eval scoreboardX worldBcsNoGlueAssumption
#eval scoreboardX worldUnconventional
#eval scoreboardX worldLk99
#eval refutedByX worldBcsPhononOnly
#eval reliesOnX phononTcCap
#eval extendedGraph.exclusive phononTcCap tcAboveCapObs
#eval extendedGraph.inconsistent worldMixed


#guard extendedGraph.wellFormed
#guard refutedBy worldBcsFullTheory == []
#guard verdictX worldBcsPhononOnly sustechNickelate == "refuted"
#guard verdictX worldBcsNoGlueAssumption sustechNickelate == "silent"
#guard verdictX worldUnconventional sustechNickelate == "supported"
#guard verdictX worldLk99 lk99Replication == "refuted"
#guard refutedByX worldBcsPhononOnly == ["SustechNickelate"]
#guard refutedByX worldUnconventional == []
#guard extendedGraph.exclusive phononTcCap tcAboveCapObs
#guard extendedGraph.inconsistent worldMixed
#guard !extendedGraph.inconsistent worldBcsPhononOnly
#guard !extendedGraph.inconsistent worldUnconventional


end Scilib.Superconductivity.Recent
