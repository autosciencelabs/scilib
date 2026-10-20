import Scilib.Basic

/-!
# Mendeleev's periodic law (1869-86): fit versus test

Domain #1 (fit versus test).  Source facts and their verification:
`parth/sources/mendeleev-s-periodic-law-1869-86/` (ledger.json, REPORT.md).  Primary sources: Mendeleev's
1869 abstract in the Zeitschrift fuer Chemie (translation of C. Giunta), the gallium paper of Lecoq de
Boisbaudran (1877), the germanium papers of Winkler (1886) and the scandium note of Nilson (1879).  Secondary
sources: Wikipedia, "Mendeleev's predicted elements", "Dmitri Mendeleev", "History of the periodic table"
and "Prout's hypothesis".

Graph shape:

* rivals: `periodicLaw` (Mendeleev), `octaves` (Newlands), `proutHypothesis` and `meyerCurve`;
* calibration: the arrangement of the known elements (`knownPeriodic`) is derived from the law and from the
  octaves alike, so it does not tell them apart;
* tests: the properties of gallium, germanium and scandium follow from the law only together with the
  auxiliary `interpolation`; the octaves, the Prout hypothesis and the Meyer curve have no edge to them;
* blame: with the weights taken as accurate the law and the tellurium-iodine order clash; Mendeleev blamed the
  weight (`teCorrection`), and the later measurement of tellurium (`teWeightMeasured`) then falls on the law;
* the Prout hypothesis meets the non-integral weights of the table.

Not modelled: that the predictions were made before the data (the language has no time order), the noble
gases, the lighter-than-hydrogen elements and coronium, the heavier elements and the rare earths, technetium
and hafnium, the low melting point of gallium that Lecoq found hard to reconcile with the theory, and the
atomic number of Moseley.
-/

namespace Scilib.MendeleevSPeriodic

/-! ## Rivals -/

def periodicLaw : Theory :=
  { statement := "The elements, if arranged according to their atomic weights, exhibit a periodicity of properties, and the magnitude of the atomic weight determines the properties of the element."
    sources := ["Mendeleev 1869"] }

def octaves : Theory :=
  { statement := "The properties of the elements recur at intervals of eight when the elements are ordered by atomic weight, like the notes within a musical scale."
    sources := ["Wikipedia, History of the periodic table", "Wikipedia, Dmitri Mendeleev"] }

def proutHypothesis : Theory :=
  { statement := "The atomic weights of the elements appear to be whole multiples of the atomic weight of hydrogen."
    sources := ["Wikipedia, Prout's hypothesis", "Wikipedia, History of the periodic table"] }

def meyerCurve : Theory :=
  { statement := "Lothar Meyer declared germanium to be eka-silicium, and added that according to his curve of the atomic volumes it should be low-melting and perhaps easy to evaporate."
    sources := ["Winkler 1886"] }

/-! ## Auxiliaries (status recorded in `sources`) -/

def interpolation : Theory :=
  { statement := "The position of a hypothetical element in a natural family approximately indicates its properties."
    sources := ["status: declared", "Lecoq de Boisbaudran 1877"] }

def weightsAccurate : Theory :=
  { statement := "The accepted atomic weights of the known elements, such as the atomic weight 128 of tellurium, are accurate."
    sources := ["status: discovered", "Mendeleev 1869"] }

/-! ## Claims read off the table of 1869 -/

def knownPeriodic : Theory :=
  { statement := "Chemically analogous elements have either similar atomic weights (Pt, Ir, Os), or weights which increase by equal increments (K, Rb, Cs)."
    sources := ["Mendeleev 1869"] }

def tableHasGaps : Theory :=
  { statement := "The arrangement leaves open places under aluminium and under silicon, marked ?=68 and ?=70."
    sources := ["Mendeleev 1869"] }

def newAnalogues : Theory :=
  { statement := "One can predict the discovery of many new elements, for example analogues of Si and Al with atomic weights of 65-75."
    sources := ["Mendeleev 1869"] }

def weightsNotWhole : Theory :=
  { statement := "Several atomic weights of the table, such as Al=27,4, Se=79,4 and Cl=35,5, are not whole multiples of the atomic weight of hydrogen, H=1."
    sources := ["Mendeleev 1869"] }

def teInverted : Theory :=
  { statement := "The table places tellurium, Te=128, in the row of oxygen, sulphur and selenium, before iodine, J=127, in the row of fluorine, chlorine and bromine."
    sources := ["Mendeleev 1869"] }

def teCorrection : Theory :=
  { statement := "A few atomic weights will probably require correction; for example Te cannot have the atomic weight 128, but rather 123-126."
    sources := ["Mendeleev 1869"] }

def teWeightMeasured : Theory :=
  { statement := "Later measurements confirmed the original atomic weight of tellurium, about 127.6, which is higher than the atomic weight of iodine."
    sources := ["Wikipedia, Dmitri Mendeleev", "Wikipedia, History of the periodic table"] }

/-! ## Readings of the new elements -/

def galliumSG : Theory :=
  { statement := "The specific gravity of gallium was 5.935, the mean of 5.90 and 5.97, and the prevision of Mendeleev is thus exactly verified."
    sources := ["Lecoq de Boisbaudran 1877"] }

def germaniumSG : Theory :=
  { statement := "The specific gravity of germanium, 5.469, is quite in agreement with Mendeleev's calculation, according to which it should be about 5.5."
    sources := ["Winkler 1886"] }

def germaniumCl4 : Theory :=
  { statement := "Germanium tetrachloride, GeCl4, has the molecular volume 113.3, calculated from its composition and specific gravity, and Mendeleev prognosticated the specific gravity of EsCl4 to be about 1.9, the volume 113, the boiling point probably a little below 100."
    sources := ["Winkler 1886"] }

def germaniumIsEkaSi : Theory :=
  { statement := "The new element germanium is no other than the eka-silicium prognosticated fifteen years ago by Mendeleev, and there can be no longer any doubt of it."
    sources := ["Winkler 1886"] }

def scandiumWeight : Theory :=
  { statement := "The atomic weight of scandium is 44; this is the value Mendeleev assigned to the predicted eka-boron."
    sources := ["Nilson 1879"] }

/-! ## Experiments -/

def galliumRun : Experiment :=
  { protocol := "Six samples of pure gallium, extracted from about 435 kg of raw materials, were united into one homogeneous piece, and its specific gravity relative to water at 23° was measured."
    observation := "Its specific gravity at 23° (relative to water at 23°) was: (1) 5.90 mean: 5.935 (2) 5.97"
    sources := ["Lecoq de Boisbaudran 1877"] }

def germaniumRun : Experiment :=
  { protocol := "The specific gravity of germanium and of germanium tetrachloride was measured by P. Mann."
    observation := "The specific gravity of germanium was found by P. Mann = 5.469. The tetrachloride is a colorless, thin liquid of specific gravity 1.887 at 18.0° as measured by P. Mann. Its boiling point is around 80°. From its composition GeCl4 and its specific gravity, its (molecular) volume is calculated as 113.3."
    sources := ["Winkler 1886"] }

def scandiumRun : Experiment :=
  { protocol := "The atomic weight of scandium was calculated for the formula ScO and for the formula Sc2O3 from the analysis of the new earth."
    observation := "The atomic weight of scandium = Sc is less than 90, calculated for the formula ScO. The atomic weight of scandium is 44."
    sources := ["Nilson 1879"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- the new elements and their readings
        Edge.interprets galliumSG galliumRun
      , Edge.interprets germaniumSG germaniumRun
      , Edge.interprets germaniumCl4 germaniumRun
      , Edge.interprets germaniumIsEkaSi germaniumRun
      , Edge.interprets scandiumWeight scandiumRun
        -- calibration: the arrangement of the known elements
      , Edge.implies periodicLaw knownPeriodic
          "Ordering the known elements by atomic weight puts chemically analogous elements together."
      , Edge.implies octaves knownPeriodic
          "The octaves put the known elements, in order of atomic weight, into groups of similar properties."
      , Edge.implies periodicLaw tableHasGaps
          "Rows of analogous elements ordered by weight leave places that no known element fills."
      , Edge.implies tableHasGaps newAnalogues
          "Open places under aluminium and silicon are predicted analogues of those elements."
        -- tests: the new elements follow from the law with its auxiliary
      , Edge.entails [periodicLaw, interpolation] galliumSG
          "The place under aluminium, with its neighbours, indicates the specific gravity of the new metal."
      , Edge.entails [periodicLaw, interpolation] germaniumSG
          "The place under silicon, with its neighbours, indicates the specific gravity of the new element."
      , Edge.entails [periodicLaw, interpolation] germaniumCl4
          "The place under silicon, with its neighbours, indicates the tetrachloride of the new element."
      , Edge.entails [periodicLaw, interpolation] scandiumWeight
          "The open place after calcium, with its neighbours, indicates the atomic weight of the new element."
      , Edge.entails [germaniumSG, germaniumCl4] germaniumIsEkaSi
          "The properties of the new element agree with those prognosticated for eka-silicium."
      , Edge.implies meyerCurve germaniumIsEkaSi
          "Meyer also declared germanium to be eka-silicium."
        -- the rivals meet the data
      , Edge.nogood [proutHypothesis, weightsNotWhole]
          "Whole multiples of the weight of hydrogen cannot give weights such as Cl=35,5."
        -- blame: the tellurium-iodine order
      , Edge.entails [periodicLaw, teInverted] teCorrection
          "If the properties follow the atomic weight, tellurium, placed before iodine, must weigh less than iodine."
      , Edge.contradicts teCorrection weightsAccurate
          "Tellurium cannot both have the accepted weight 128 and a weight of 123-126."
      , Edge.contradicts teCorrection teWeightMeasured
          "A weight of 123-126 for tellurium cannot be the measured weight of about 127.6."
      ] }

/-- Named checks; the verifier mutates the graph and runs these on every mutant. -/
def checks (g : Graph) : List (String × Bool) :=
  [ ("graph is well formed", g.wellFormed)
    -- readings
  , ("gallium reading", g.readings.contains (galliumSG, galliumRun))
  , ("germanium density reading", g.readings.contains (germaniumSG, germaniumRun))
  , ("germanium tetrachloride reading", g.readings.contains (germaniumCl4, germaniumRun))
  , ("germanium identity reading", g.readings.contains (germaniumIsEkaSi, germaniumRun))
  , ("scandium reading", g.readings.contains (scandiumWeight, scandiumRun))
    -- calibration: the known elements do not tell the law and the octaves apart
  , ("the arrangement is derived from the law", (g.derive [periodicLaw]).contains knownPeriodic)
  , ("the arrangement is derived from the octaves", (g.derive [octaves]).contains knownPeriodic)
  , ("the law leaves gaps", (g.derive [periodicLaw]).contains tableHasGaps)
  , ("the gaps predict new analogues", (g.derive [tableHasGaps]).contains newAnalogues)
  , ("the law predicts new analogues", (g.derive [periodicLaw]).contains newAnalogues)
  , ("the octaves leave no gaps", !(g.derive [octaves]).contains tableHasGaps)
  , ("the octaves predict no new analogues", !(g.derive [octaves]).contains newAnalogues)
    -- tests: the new elements follow from the law with the auxiliary
  , ("the law with its auxiliary explains gallium", g.supports [periodicLaw, interpolation] galliumRun)
  , ("the law with its auxiliary explains germanium", g.supports [periodicLaw, interpolation] germaniumRun)
  , ("the law with its auxiliary explains scandium", g.supports [periodicLaw, interpolation] scandiumRun)
  , ("gallium needs the law", !(g.derive [interpolation]).contains galliumSG)
  , ("gallium needs the auxiliary", !(g.derive [periodicLaw]).contains galliumSG)
  , ("germanium density needs the law", !(g.derive [interpolation]).contains germaniumSG)
  , ("germanium density needs the auxiliary", !(g.derive [periodicLaw]).contains germaniumSG)
  , ("germanium tetrachloride needs the law", !(g.derive [interpolation]).contains germaniumCl4)
  , ("germanium tetrachloride needs the auxiliary", !(g.derive [periodicLaw]).contains germaniumCl4)
  , ("scandium needs the law", !(g.derive [interpolation]).contains scandiumWeight)
  , ("scandium needs the auxiliary", !(g.derive [periodicLaw]).contains scandiumWeight)
  , ("germanium identity follows from density and tetrachloride",
      (g.derive [germaniumSG, germaniumCl4]).contains germaniumIsEkaSi)
  , ("the density alone does not identify germanium", !(g.derive [germaniumSG]).contains germaniumIsEkaSi)
  , ("the tetrachloride alone does not identify germanium", !(g.derive [germaniumCl4]).contains germaniumIsEkaSi)
  , ("the law with its auxiliary identifies germanium",
      (g.derive [periodicLaw, interpolation]).contains germaniumIsEkaSi)
    -- the rivals do not reach the new elements
  , ("the octaves with the auxiliary do not explain gallium", !g.supports [octaves, interpolation] galliumRun)
  , ("the octaves with the auxiliary do not explain scandium", !g.supports [octaves, interpolation] scandiumRun)
  , ("the Prout hypothesis does not explain gallium", !g.supports [proutHypothesis, interpolation] galliumRun)
  , ("the Meyer curve does not give the germanium density", !(g.derive [meyerCurve, interpolation]).contains germaniumSG)
  , ("the Meyer curve identifies germanium", g.supports [meyerCurve] germaniumRun)
    -- the Prout hypothesis meets the weights of the table
  , ("the Prout hypothesis meets the non-integral weights", g.inconsistent [proutHypothesis, weightsNotWhole])
  , ("the Prout hypothesis alone is consistent", !g.inconsistent [proutHypothesis])
  , ("the non-integral weights alone are consistent", !g.inconsistent [weightsNotWhole])
  , ("the law is consistent with every claim read off the table",
      !g.inconsistent [periodicLaw, knownPeriodic, tableHasGaps, newAnalogues, weightsNotWhole, teInverted])
  , ("the Prout hypothesis meets the table with the law", g.inconsistent [proutHypothesis, periodicLaw, weightsNotWhole])
    -- blame: the tellurium-iodine order
  , ("the law with the placement requires a correction",
      (g.derive [periodicLaw, teInverted]).contains teCorrection)
  , ("the correction needs the law", !(g.derive [teInverted]).contains teCorrection)
  , ("the correction needs the placement", !(g.derive [periodicLaw]).contains teCorrection)
  , ("the law, the placement and accurate weights clash",
      g.inconsistent [periodicLaw, teInverted, weightsAccurate])
  , ("the law and the placement alone are consistent", !g.inconsistent [periodicLaw, teInverted])
  , ("accurate weights alone are consistent", !g.inconsistent [weightsAccurate])
  , ("the law with accurate weights alone is consistent", !g.inconsistent [periodicLaw, weightsAccurate])
  , ("the correction excludes the accepted weight", g.exclusive teCorrection weightsAccurate)
  , ("the measured weight and the correction exclude each other", g.exclusive teCorrection teWeightMeasured)
  , ("the measured weight now falls on the law",
      g.inconsistent [periodicLaw, teInverted, teWeightMeasured])
  , ("the measured weight alone is consistent", !g.inconsistent [teWeightMeasured])
  , ("the measured weight and the placement alone are consistent", !g.inconsistent [teInverted, teWeightMeasured])
  , ("the measured weight and the law alone are consistent", !g.inconsistent [periodicLaw, teWeightMeasured])
  , ("the measured weight agrees with the accepted weight", !g.inconsistent [weightsAccurate, teWeightMeasured])
  ]

#guard (checks evidenceGraph).all (·.2)

end Scilib.MendeleevSPeriodic
