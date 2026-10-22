import Scilib.Basic

/-!
# The ether and the speed of light (1810-1938): can the data tell the rivals apart?

Domain #10 (resolving power).  Source facts and their verification:
`parth/sources/the-ether-and-the-speed-of-light-1810-1938/` (ledger.json, REPORT.md).  Primary sources:
A. A. Michelson and E. W. Morley, "On the relative motion of the Earth and the luminiferous ether",
Am. J. Sci. 34 (1887), and A. Einstein, "On the electrodynamics of moving bodies" (1905).  Secondary
sources: Wikipedia (Lorentz ether theory, Michelson-Morley experiment, Kennedy-Thorndike experiment,
Fizeau experiment, aether drag hypothesis, tests of special relativity) and the Stanford Encyclopedia
entry on the conventionality of simultaneity.

Graph shape (as in `BaadeSTwo.lean`):

* rivals: `stationaryEther`, `etherDrag`, `lorentzEther` and `relativity`;
* observations: two `Experiment`s, each with its `interprets` edge: the 1887 interferometer and
  Fizeau's moving water (as Michelson and Morley describe it);
* the Michelson-Morley null result refutes the stationary ether only together with the hidden
  assumption `armsKeepLength`; the Lorentz ether theory denies that assumption, so the same data spare it;
* `observableContent` is what the Lorentz ether theory and special relativity share.  The core has no
  "empirically equivalent" edge, so the equivalence is modelled as two `entails` edges into the shared
  observable content, not as `implies` both ways (which would make relativity assert the ether);
* `noSeparation`: from the shared content and the fact that only the two-way speed is measured, no
  experiment tells the two apart.  Einstein's clock convention is what lets relativity derive the content.

Not modelled (no primary text available): Kennedy-Thorndike 1932, Ives-Stilwell 1938, the
Kaufmann-Bucherer mass-velocity experiments, de Sitter's double stars, Sagnac, Trouton-Noble.
-/

namespace Scilib.TheEtherAnd

/-! ## Rivals -/

def stationaryEther : Theory :=
  { statement := "Stationary ether (Fresnel): the ether is at rest except in the interior of transparent media."
    sources := ["Michelson and Morley 1887", "Wikipedia, Michelson-Morley experiment"] }

def etherDrag : Theory :=
  { statement := "Ether drag (Stokes): the ether at the Earth's surface is at rest with regard to the Earth."
    sources := ["Michelson and Morley 1887", "Wikipedia, aether drag hypothesis"] }

def lorentzEther : Theory :=
  { statement := "Lorentz ether theory: the ether is immobile, and bodies moving through it contract along the direction of motion; an observer moving with the Earth does not notice the contraction because all other instruments contract at the same ratio."
    sources := ["Wikipedia, Lorentz ether theory", "Wikipedia, Kennedy-Thorndike experiment"] }

def relativity : Theory :=
  { statement := "Special relativity: no property of observed facts corresponds to absolute rest, light travels in empty space with a velocity c independent of the motion of the emitting body, and the ether is superfluous."
    sources := ["Einstein 1905"] }

def observableContent : Theory :=
  { statement := "Shared observable content: the Lorentz ether theory and special relativity give the same experimental predictions, since both lead to the complete Lorentz transformation."
    sources := ["Wikipedia, Lorentz ether theory", "Wikipedia, tests of special relativity"] }

/-! ## Hidden assumptions (status recorded in `sources`) -/

def armsKeepLength : Theory :=
  { statement := "The arms of the interferometer keep the same length in every orientation to the ether wind: bodies moving through the ether do not contract."
    sources := ["status: suspected", "Michelson and Morley 1887"] }

def twoWayOnly : Theory :=
  { statement := "Only the round-trip (two-way) speed of light is measured; the one-way speed depends on the definition of simultaneity."
    sources := ["status: suspected", "Wikipedia, tests of special relativity", "Stanford Encyclopedia, conventionality of simultaneity"] }

def syncConvention : Theory :=
  { statement := "Clocks at two places are synchronised by the convention that the time light takes from A to B equals the time it takes from B to A."
    sources := ["status: declared", "Einstein 1905"] }

/-! ## Predictions and readings -/

def etherWindShift : Theory :=
  { statement := "If the ether is at rest, turning the whole apparatus through 90 degrees should displace the interference fringes by about 0.4 fringe."
    sources := ["Michelson and Morley 1887"] }

def armsContract : Theory :=
  { statement := "Under the Lorentz ether theory the arm along the direction of motion through the ether is shorter than the arm across it, so the arm lengths depend on orientation."
    sources := ["status: inference", "Wikipedia, Lorentz ether theory"] }

def nullFringeShift : Theory :=
  { statement := "On turning the apparatus, any displacement due to the relative motion of the earth and the luminiferous ether was not much greater than 0.01 of the distance between the fringes."
    sources := ["Michelson and Morley 1887"] }

def fizeauPartial : Theory :=
  { statement := "In moving water the ether is carried along with a velocity less than that of the medium, so light is dragged only partly."
    sources := ["Michelson and Morley 1887"] }

def noSeparation : Theory :=
  { statement := "No experiment separates the Lorentz ether theory from special relativity: they differ only in a unique rest frame, which is empirically undetectable."
    sources := ["Wikipedia, Lorentz ether theory", "Wikipedia, tests of special relativity"] }

/-! ## Experiments -/

def interferometer1887 : Experiment :=
  { protocol := "Michelson and Morley's interferometer, mounted on a massive stone floating on mercury and revolved slowly (one turn in six minutes), with the fringes read on a micrometer."
    observation := "The displacement of the interference fringes on turning the apparatus was not much greater than 0.01 of the distance between the fringes."
    sources := ["Michelson and Morley 1887"] }

def fizeauWater : Experiment :=
  { protocol := "Fizeau's experiment on light passing through moving water, as cited by Michelson and Morley."
    observation := "Fizeau's experiment confirmed the hypothesis that the ether moves with a velocity less than the velocity of the medium."
    sources := ["Michelson and Morley 1887, citing Fizeau"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- observations and their readings
        Edge.interprets nullFringeShift interferometer1887
      , Edge.interprets fizeauPartial fizeauWater
      -- the stationary ether with fixed arms predicts a shift
      , Edge.entails [stationaryEther, armsKeepLength] etherWindShift
          "Michelson and Morley expected 0.4 fringe from the Earth's orbital motion through a stationary ether."
      , Edge.nogood [etherWindShift, nullFringeShift]
          "About 0.4 fringe expected, not much more than 0.01 found."
      -- the Lorentz ether theory denies the hidden assumption
      , Edge.entails [lorentzEther] stationaryEther
          "Lorentz ether theory keeps the ether at rest."
      , Edge.entails [lorentzEther] armsContract
          "Moving bodies contract along the direction of motion."
      , Edge.entails [stationaryEther, armsContract] nullFringeShift
          "The contraction of the arm along the motion cancels the delay of the ether wind."
      , Edge.entails [lorentzEther] observableContent
          "Length contraction and time dilation in the preferred frame give the complete Lorentz transformation."
      -- special relativity reaches the same content
      , Edge.entails [relativity, syncConvention] observableContent
          "With Einstein's definition of common time the relativity and light-speed postulates give the Lorentz transformation."
      , Edge.entails [observableContent] nullFringeShift
          "Inference by the graph author: Lorentz covariance makes motion through the ether undetectable."
      , Edge.entails [observableContent] fizeauPartial
          "Lorentz could explain the Fizeau experiment; relativity gives the velocity-addition formula, which reduces to Fresnel's drag at small speeds."
      -- ether drag
      , Edge.entails [etherDrag] nullFringeShift
          "Complete aether dragging explains the negative outcome of the aether drift experiments."
      , Edge.contradicts etherDrag fizeauPartial
          "Inference by the graph author: complete entrainment by matter is not partial entrainment."
      -- the stationary ether and Fizeau
      , Edge.entails [stationaryEther] fizeauPartial
          "Fresnel's partial drag was confirmed by the Fizeau experiment."
      -- no experiment separates the two
      , Edge.entails [observableContent, twoWayOnly] noSeparation
          "With only two-way speeds measurable, the unique rest frame of the Lorentz ether theory plays no role in any prediction."
      ] }

/-! ## Checks: what `lake build` verifies -/

/-- Named checks; the verifier mutates the graph and runs these on every mutant. -/
def checks (g : Graph) : List (String × Bool) :=
  [ ("graph is well formed", g.wellFormed)
    -- the rivals
  , ("stationary ether excludes ether drag", g.exclusive stationaryEther etherDrag)
  , ("Lorentz ether theory excludes fixed arm length", g.exclusive lorentzEther armsKeepLength)
    -- Michelson-Morley refutes the stationary ether only with the fixed arm length
  , ("MM refutes the stationary ether with fixed arms",
      g.refutes [stationaryEther, armsKeepLength] interferometer1887)
  , ("blame: refutation needs fixed arms", !g.refutes [stationaryEther] interferometer1887)
  , ("blame: refutation needs the stationary ether", !g.refutes [armsKeepLength] interferometer1887)
  , ("the prediction needs fixed arms", !(g.derive [stationaryEther]).contains etherWindShift)
  , ("the prediction needs the stationary ether", !(g.derive [armsKeepLength]).contains etherWindShift)
  , ("the stationary ether with fixed arms predicts a shift",
      (g.derive [stationaryEther, armsKeepLength]).contains etherWindShift)
    -- three rivals survive the same data
  , ("MM spares the Lorentz ether theory", !g.refutes [lorentzEther] interferometer1887)
  , ("Lorentz ether theory explains MM", g.supports [lorentzEther] interferometer1887)
  , ("Lorentz ether theory derives the contraction", (g.derive [lorentzEther]).contains armsContract)
  , ("Lorentz ether theory keeps the ether", (g.derive [lorentzEther]).contains stationaryEther)
  , ("relativity explains MM with the clock convention",
      g.supports [relativity, syncConvention] interferometer1887)
  , ("relativity needs the clock convention", !g.supports [relativity] interferometer1887)
  , ("the clock convention alone derives no content", !(g.derive [syncConvention]).contains observableContent)
  , ("stationary ether with contraction explains MM", g.supports [stationaryEther, armsContract] interferometer1887)
  , ("contraction alone does not explain MM", !g.supports [armsContract] interferometer1887)
  , ("relativity derives no ether", !(g.derive [relativity, syncConvention]).contains stationaryEther)
  , ("ether drag explains MM", g.supports [etherDrag] interferometer1887)
  , ("the stationary ether alone does not explain MM", !g.supports [stationaryEther] interferometer1887)
    -- Fizeau separates drag from the rest
  , ("Fizeau refutes ether drag", g.refutes [etherDrag] fizeauWater)
  , ("ether drag excludes the Fizeau reading", g.exclusive etherDrag fizeauPartial)
  , ("stationary ether explains Fizeau", g.supports [stationaryEther] fizeauWater)
  , ("Fizeau spares the Lorentz ether theory", !g.refutes [lorentzEther] fizeauWater)
  , ("Lorentz ether theory explains Fizeau", g.supports [lorentzEther] fizeauWater)
  , ("relativity explains Fizeau with the clock convention",
      g.supports [relativity, syncConvention] fizeauWater)
  , ("Fizeau spares relativity", !g.refutes [relativity, syncConvention] fizeauWater)
    -- nothing separates the Lorentz ether theory from relativity
  , ("shared content from the Lorentz ether theory",
      (g.derive [lorentzEther]).contains observableContent)
  , ("shared content from relativity with the convention",
      (g.derive [relativity, syncConvention]).contains observableContent)
  , ("relativity without the convention derives no content",
      !(g.derive [relativity]).contains observableContent)
  , ("no separation", (g.derive [lorentzEther, twoWayOnly]).contains noSeparation)
  , ("no separation from relativity", (g.derive [relativity, syncConvention, twoWayOnly]).contains noSeparation)
  , ("no separation needs the two-way fact", !(g.derive [observableContent]).contains noSeparation)
  , ("no separation needs the shared content", !(g.derive [twoWayOnly]).contains noSeparation)
    -- a rival alone is not an observation
  , ("a rival alone is not an observation", !(g.derive [lorentzEther]).contains etherWindShift)
    -- readings
  , ("MM reading", g.readings.contains (nullFringeShift, interferometer1887))
  , ("Fizeau reading", g.readings.contains (fizeauPartial, fizeauWater))
  ]

#guard (checks evidenceGraph).all (·.2)

end Scilib.TheEtherAnd
