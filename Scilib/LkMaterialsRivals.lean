import Scilib.Basic

/-!
# LK-99 (2023): conflicting results and replication

Domain #5 (conflicting results and replication).  Source facts and their verification:
`parth/sources/lk-99-2023-materials-rivals-room-temperature-sup/` (ledger.json, REPORT.md).  Primary sources:
the two preprints of Lee et al. (arXiv:2307.12008 and arXiv:2307.12037), the density functional theory paper of
Griffin (arXiv:2307.16892), the Cu2S replication of Zhu et al. (arXiv:2308.04353), the percolation paper of Hou
et al. (arXiv:2308.05778) and the single crystals of Puphal et al. (arXiv:2308.06256).  Secondary source:
Wikipedia, "LK-99".

Graph shape (as in `OperaFasterThan.lean`):

* rivals: `superconductor` (the claim), `cu2sArtifact` (the resistivity drop is the Cu2S transition) and
  `insulator` (pure crystals are a diamagnetic insulator with a small ferromagnetic part);
* the claim explains Lee's resistivity jump and levitation only with two auxiliaries, `samplePure` and
  `contactsReliable`; the Cu2S rival explains the same jump with `sampleHasCu2S`;
* replications discount the positive results by blame: the X-ray pattern shows Cu2S, so `samplePure` is
  refuted and the superconductor claim is not yet; the pure crystals then refute the claim itself;
* the DFT flat bands are a result for an idealised structure: they reach the real sample only through
  `dftRepresentsSample`, which the uneven Cu distribution of the real crystals contradicts.

Not modelled: the 2020-2023 history of the claim, the other replications (more than 15 labs), the Southeast
University low-temperature flake, the heat capacity and SQUID data of Lee et al., and the other DFT papers.
-/

namespace Scilib.LkMaterialsRivals

/-! ## Rivals -/

def superconductor : Theory :=
  { statement := "LK-99, a modified lead-apatite with the composition Pb10-xCux(PO4)6O (0.9<x<1.1), is a superconductor at room temperature and atmospheric pressure."
    sources := ["Lee et al. 2023a", "Lee et al. 2023b"] }

def cu2sArtifact : Theory :=
  { statement := "The superconducting behavior of LK-99 is due to a reduction in resistivity caused by the first order structural phase transition of Cu2S at around 385 K."
    sources := ["Zhu et al. 2023"] }

def insulator : Theory :=
  { statement := "Pure Pb10-xCux(PO4)6O is a highly insulating and optically transparent non-magnetic insulator with a small ferromagnetic component, and it is not a superconductor."
    sources := ["Puphal et al. 2023", "Wikipedia, LK-99"] }

def sampleHasCu2S : Theory :=
  { statement := "The reported LK-99 sample contained a certain amount of Cu2S impurity, with a Cu2S content of approximately 5% in sample 1 and 70% in sample 2 of one replication."
    sources := ["Lee et al. 2023a", "Zhu et al. 2023"] }

/-! ## Auxiliaries (status recorded in `sources`) -/

def samplePure : Theory :=
  { statement := "The LK-99 sample consists of the Cu-substituted lead-apatite phase, so that its resistivity and its magnetic response are those of that phase."
    sources := ["status: discovered", "Zhu et al. 2023", "Lee et al. 2023a"] }

def contactsReliable : Theory :=
  { statement := "The resistivity measured on the LK-99 samples is the resistivity of the bulk and not that of a Cu/Pb current channel through it."
    sources := ["status: suspected", "Lee et al. 2023b"] }

def dftRepresentsSample : Theory :=
  { statement := "The structure of the density functional theory calculation, Cu-substituted lead phosphate apatite, represents the real LK-99 sample."
    sources := ["status: discovered", "Puphal et al. 2023", "Wikipedia, LK-99"] }

/-! ## Inference -/

def flatBandsInSample : Theory :=
  { statement := "If the structure of the calculation represents the real sample, the sample has correlated isolated flat bands at the Fermi level."
    sources := ["status: inference", "Griffin 2023"] }

/-! ## Readings -/

def resDropSC : Theory :=
  { statement := "Below the superconducting critical temperature Tc, found at the jump in resistivity near 104.8 C (377.95 K), the resistivity with noise signals can be regarded as zero."
    sources := ["Lee et al. 2023b"] }

def resDropStruct : Theory :=
  { statement := "The superconductivity-like jump in resistivity of LK-99 reported by Lee et al. is caused by the structural phase transition of the impurity Cu2S, whose resistivity decreases by 3 - 4 orders of magnitude around 385 K."
    sources := ["Zhu et al. 2023"] }

def levMeissner : Theory :=
  { statement := "The levitation phenomenon of sample 4 at room temperature and atmospheric pressure indicates the presence of a superconducting phase, although the levitation is not perfect."
    sources := ["Lee et al. 2023b"] }

def levMagnetism : Theory :=
  { statement := "Magnetic levitation of the sample is not synonymous with the Meissner effect, and the sample shows a diamagnetic response with a small ferromagnetic component."
    sources := ["Hou et al. 2023", "Puphal et al. 2023", "Wikipedia, LK-99"] }

def xrdCu2S : Theory :=
  { statement := "The main X-ray diffraction peaks of LK-99 match the lead-apatite structure, and few Cu2S impurities also show."
    sources := ["Lee et al. 2023a"] }

/-- A computed result, not a recorded observation, so it is a claim and has no experiment. -/
def flatBands : Theory :=
  { statement := "Density functional theory calculations on Cu-substituted lead phosphate apatite identify correlated isolated flat bands at the Fermi level, a common signature of high transition temperatures in already-established families of superconductors."
    sources := ["Griffin 2023"] }

def cu2sDrop : Theory :=
  { statement := "The resistivity of Cu2S decreased by 3 - 4 orders of magnitude around 385 K, close to the reported transition temperature, and a wide thermal hysteresis of 13.1 K indicates a first-order phase transition."
    sources := ["Zhu et al. 2023"] }

def mixtureNoZero : Theory :=
  { statement := "The mixtures of LK-99 and Cu2S show a sharp resistivity transition at the temperature consistent with the reported findings, but without zero resistance."
    sources := ["Zhu et al. 2023"] }

def crystalsInsulating : Theory :=
  { statement := "The crystals are highly insulating and optically transparent, with the diamagnetic response characteristic of a non-magnetic insulator, as well as a small ferromagnetic component, and no anomalies indicative of phase transitions are observed."
    sources := ["Puphal et al. 2023"] }

def cuUneven : Theory :=
  { statement := "X-ray analysis of phase-pure single crystals reveals an uneven distribution of the substituted Cu throughout the sample."
    sources := ["Puphal et al. 2023"] }

def pelletVaries : Theory :=
  { statement := "Four distinct types of resistivity behaviors are observed within samples from the same pellet."
    sources := ["Hou et al. 2023"] }

def noMeissner : Theory :=
  { statement := "It is important to note that the Meissner effect was not observed in the magnetization measurements of the Cu-doped apatite samples."
    sources := ["Hou et al. 2023"] }

/-! ## Experiments -/

def leeResistivity : Experiment :=
  { protocol := "The temperature dependence of the resistivity of sample 2 of LK-99 was measured at 30 mA by the four-probe method."
    observation := "A jump in resistivity appears near 104.8 C (377.95 K)."
    sources := ["Lee et al. 2023b"] }

def levitationVideo : Experiment :=
  { protocol := "Sample 4, heat-treated with sample 2, was held over a magnet at room temperature and atmospheric pressure, and a video of the levitation was recorded."
    observation := "The levitation phenomenon was measured at room temperature and atmospheric pressure for sample 4, heat-treated with sample 2, although the levitation is not perfect."
    sources := ["Lee et al. 2023b", "Wikipedia, LK-99"] }

def leeXrd : Experiment :=
  { protocol := "The X-ray diffraction pattern of LK-99 was matched with the Crystallography Open Database using the QualX2.0 software."
    observation := "The main peaks were well matched with the lead-apatite (AP) structure, and few Cu2S impurities also shown."
    sources := ["Lee et al. 2023a"] }

def cu2sRun : Experiment :=
  { protocol := "The resistivity of a pressed pellet of pure Cu2S powder was measured from 2 K to 400 K by a standard 4-probe method."
    observation := "At around 385 K a significant decrease in the resistivity of Cu2S is observed, from 13.7 Ohm cm at 385.6 K to 0.006 Ohm cm at 381.5 K, a drop of 3 - 4 orders of magnitude, with a thermal hysteresis of 13.1 K between the cooling and warming curves."
    sources := ["Zhu et al. 2023"] }

def zhuMixture : Experiment :=
  { protocol := "LK-99 was synthesized with two different Cu2S contents, and the resistivity of the two mixtures of LK-99 and Cu2S was measured from 2 K to 400 K."
    observation := "A sharp drop in resistivity around 370 K with a pronounced thermal hysteresis was observed, and zero resistivity was not observed below the transition temperature."
    sources := ["Zhu et al. 2023"] }

def puphalRun : Experiment :=
  { protocol := "Phase-pure single crystals of Pb10-xCux(PO4)6O with a copper doping level of x about 1 were synthesized, and their appearance, X-ray structure and magnetic susceptibility were measured."
    observation := "The crystals are highly insulating and optically transparent, X-ray analysis reveals an uneven distribution of the substituted Cu throughout the sample, the magnetic susceptibility shows a diamagnetic response characteristic of a non-magnetic insulator and a small ferromagnetic component, and no anomalies indicative of phase transitions are observed."
    sources := ["Puphal et al. 2023"] }

def houRun : Experiment :=
  { protocol := "The temperature-dependent resistivity and the magnetization of synthesized Pb10-xCux(PO4)6O samples were measured, after X-ray diffraction confirmed the structure."
    observation := "Four distinct types of resistivity behaviors were observed within samples from the same pellet, and the Meissner effect was not observed in the magnetization measurements."
    sources := ["Hou et al. 2023"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- observations and their readings
        Edge.interprets resDropSC leeResistivity
      , Edge.interprets resDropStruct leeResistivity
      , Edge.interprets levMeissner levitationVideo
      , Edge.interprets levMagnetism levitationVideo
      , Edge.interprets xrdCu2S leeXrd
      , Edge.interprets cu2sDrop cu2sRun
      , Edge.interprets mixtureNoZero zhuMixture
      , Edge.interprets crystalsInsulating puphalRun
      , Edge.interprets cuUneven puphalRun
      , Edge.interprets pelletVaries houRun
      , Edge.interprets noMeissner houRun
      -- the rivals and their readings
      , Edge.contradicts superconductor insulator
          "Pure crystals cannot both be insulators that are not superconductors and be room-temperature superconductors."
      , Edge.contradicts resDropSC resDropStruct
          "The jump cannot be both the superconducting transition and the Cu2S structural transition."
      , Edge.contradicts levMeissner levMagnetism
          "Levitation cannot be both the Meissner effect of a superconducting phase and ordinary diamagnetism with a ferromagnetic part."
      -- the claim explains the jump and the levitation only with its auxiliaries
      , Edge.entails [superconductor, samplePure, contactsReliable] resDropSC
          "A superconducting phase in the sample, measured as bulk resistivity, jumps at the critical temperature."
      , Edge.entails [superconductor, samplePure] levMeissner
          "A superconducting phase in the sample shows the Meissner effect as levitation."
      -- the Cu2S rival explains the same jump
      , Edge.entails [cu2sArtifact, sampleHasCu2S] resDropStruct
          "Cu2S in the sample, with its own structural transition near 385 K, gives the same drop in resistivity."
      , Edge.implies insulator levMagnetism
          "A diamagnetic insulator with a small ferromagnetic part gives the partial levitation without superconductivity."
      -- replications: blame falls on the purity of the sample
      , Edge.implies xrdCu2S sampleHasCu2S
          "Cu2S peaks in the X-ray pattern mean the sample contains Cu2S."
      , Edge.nogood [samplePure, sampleHasCu2S]
          "A sample with a Cu2S impurity is not a single apatite phase."
      , Edge.entails [cu2sDrop, mixtureNoZero] cu2sArtifact
          "Pure Cu2S drops like LK-99 at a close temperature, and mixtures show the transition without zero resistance."
      , Edge.implies crystalsInsulating insulator
          "Phase-pure crystals that insulate and show only ordinary magnetism are an insulator."
      , Edge.nogood [superconductor, samplePure, noMeissner]
          "A superconducting apatite phase would show the Meissner effect."
      , Edge.nogood [contactsReliable, pelletVaries]
          "A bulk resistivity of one pellet would not take four different forms."
      -- the density functional theory result reaches the sample only through an assumption
      , Edge.entails [flatBands, dftRepresentsSample] flatBandsInSample
          "Flat bands of the calculated structure are flat bands of the sample only if the structure represents the sample."
      , Edge.nogood [dftRepresentsSample, cuUneven]
          "An ordered calculated structure does not match crystals with unevenly distributed Cu."
      ] }

/-! ## Checks: what `lake build` verifies -/

/-- Named checks; the verifier mutates the graph and runs these on every mutant. -/
def checks (g : Graph) : List (String × Bool) :=
  [ ("graph is well formed", g.wellFormed)
    -- readings
  , ("resistivity jump, superconducting reading", g.readings.contains (resDropSC, leeResistivity))
  , ("resistivity jump, Cu2S reading", g.readings.contains (resDropStruct, leeResistivity))
  , ("levitation, Meissner reading", g.readings.contains (levMeissner, levitationVideo))
  , ("levitation, ordinary magnetism reading", g.readings.contains (levMagnetism, levitationVideo))
  , ("X-ray reading", g.readings.contains (xrdCu2S, leeXrd))
  , ("pure Cu2S reading", g.readings.contains (cu2sDrop, cu2sRun))
  , ("mixture reading", g.readings.contains (mixtureNoZero, zhuMixture))
  , ("single crystal reading", g.readings.contains (crystalsInsulating, puphalRun))
  , ("uneven Cu reading", g.readings.contains (cuUneven, puphalRun))
  , ("pellet reading", g.readings.contains (pelletVaries, houRun))
  , ("no Meissner reading", g.readings.contains (noMeissner, houRun))
    -- the rivals and their readings
  , ("the claim excludes the insulator", g.exclusive superconductor insulator)
  , ("the two readings of the jump exclude each other", g.exclusive resDropSC resDropStruct)
  , ("the two readings of the levitation exclude each other", g.exclusive levMeissner levMagnetism)
    -- the claim explains Lee's data with its auxiliaries
  , ("the claim with a pure sample and bulk contacts explains the jump",
      g.supports [superconductor, samplePure, contactsReliable] leeResistivity)
  , ("the jump reading needs the claim",
      !(g.derive [samplePure, contactsReliable]).contains resDropSC)
  , ("the jump reading needs the pure sample",
      !(g.derive [superconductor, contactsReliable]).contains resDropSC)
  , ("the jump reading needs the contacts",
      !(g.derive [superconductor, samplePure]).contains resDropSC)
  , ("the claim with a pure sample explains the levitation",
      g.supports [superconductor, samplePure] levitationVideo)
  , ("the levitation reading needs the claim",
      !(g.derive [samplePure]).contains levMeissner)
  , ("the levitation reading needs the pure sample",
      !(g.derive [superconductor]).contains levMeissner)
    -- the Cu2S rival explains the same jump
  , ("the Cu2S rival with Cu2S in the sample explains the jump",
      g.supports [cu2sArtifact, sampleHasCu2S] leeResistivity)
  , ("the Cu2S reading needs the rival",
      !(g.derive [sampleHasCu2S]).contains resDropStruct)
  , ("the Cu2S reading needs Cu2S in the sample",
      !(g.derive [cu2sArtifact]).contains resDropStruct)
  , ("the insulator explains the levitation as ordinary magnetism",
      g.supports [insulator] levitationVideo)
  , ("both explanations of the jump together are inconsistent",
      g.inconsistent [superconductor, samplePure, contactsReliable, cu2sArtifact, sampleHasCu2S])
    -- blame: the X-ray pattern refutes the pure sample, not the claim
  , ("the X-ray reading proves Cu2S in the sample", (g.derive [xrdCu2S]).contains sampleHasCu2S)
  , ("Cu2S in the sample excludes a pure sample", g.inconsistent [samplePure, sampleHasCu2S])
  , ("a pure sample alone is consistent", !g.inconsistent [samplePure])
  , ("Cu2S in the sample alone is consistent", !g.inconsistent [sampleHasCu2S])
  , ("the X-ray pattern refutes the pure sample", g.inconsistent [xrdCu2S, samplePure])
  , ("Cu2S in the sample does not refute the claim", !g.inconsistent [superconductor, sampleHasCu2S])
  , ("the claim with an impure sample still stands",
      !g.inconsistent [superconductor, xrdCu2S])
    -- replications support the Cu2S rival
  , ("pure Cu2S and the mixtures prove the Cu2S rival",
      (g.derive [cu2sDrop, mixtureNoZero]).contains cu2sArtifact)
  , ("pure Cu2S alone does not prove the Cu2S rival",
      !(g.derive [cu2sDrop]).contains cu2sArtifact)
  , ("the mixtures alone do not prove the Cu2S rival",
      !(g.derive [mixtureNoZero]).contains cu2sArtifact)
    -- Hou: no Meissner effect, and one pellet gives four behaviours
  , ("no Meissner effect refutes the claim with a pure sample",
      g.refutes [superconductor, samplePure] houRun)
  , ("no Meissner effect is consistent with the claim alone",
      !g.inconsistent [superconductor, noMeissner])
  , ("no Meissner effect is consistent with a pure sample alone",
      !g.inconsistent [samplePure, noMeissner])
  , ("no Meissner effect is consistent with the claim and a pure sample alone",
      !g.inconsistent [superconductor, samplePure])
  , ("the four behaviours refute bulk contacts", g.inconsistent [contactsReliable, pelletVaries])
  , ("bulk contacts alone are consistent", !g.inconsistent [contactsReliable])
  , ("the four behaviours alone are consistent", !g.inconsistent [pelletVaries])
    -- pure crystals refute the claim itself
  , ("the pure crystals prove the insulator", (g.derive [crystalsInsulating]).contains insulator)
  , ("the pure crystals refute the claim", g.refutes [superconductor] puphalRun)
  , ("the pure crystals do not refute the insulator", !g.refutes [insulator] puphalRun)
  , ("the claim and the pure crystals are inconsistent", g.inconsistent [superconductor, crystalsInsulating])
    -- density functional theory: the flat bands reach the sample only through an assumption
  , ("flat bands and the representing structure give flat bands in the sample",
      (g.derive [flatBands, dftRepresentsSample]).contains flatBandsInSample)
  , ("the flat bands alone do not give flat bands in the sample",
      !(g.derive [flatBands]).contains flatBandsInSample)
  , ("the representing structure alone does not give flat bands in the sample",
      !(g.derive [dftRepresentsSample]).contains flatBandsInSample)
  , ("the flat bands do not prove the claim", !(g.derive [flatBands, dftRepresentsSample]).contains superconductor)
  , ("uneven Cu refutes the representing structure", g.inconsistent [dftRepresentsSample, cuUneven])
  , ("the representing structure alone is consistent", !g.inconsistent [dftRepresentsSample])
  , ("uneven Cu alone is consistent", !g.inconsistent [cuUneven])
  , ("uneven Cu refutes the representing structure through the crystals",
      g.refutes [dftRepresentsSample] puphalRun)
  ]

#guard (checks evidenceGraph).all (·.2)

end Scilib.LkMaterialsRivals
