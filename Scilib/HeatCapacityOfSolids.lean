import Scilib.Basic

/-!
# Example: the heat capacity of solids
Dulong-Petit, Einstein, Debye, and the electron gas (1819 to 1930s)

This is a condensed-matter counterpart of the Earth-shape model graph.  It uses
only the primitives of `Basic.lean`: `entails`, `interprets` and `contradicts`
(which is `entails` of `absurd`).  It is laid out in the same layers as the
model graph.

| model graph (colour)      | here                                                     |
|---------------------------|----------------------------------------------------------|
| theories (blue)           | `classicalSolid`, `einsteinSolid`, `debyeSolid`, `drudeElectrons`, `sommerfeldElectrons` |
| claims (white)            | `lattice...`, `electrons...`, `...Prediction`            |
| experiments (green)       | raw `Experiment` records, each with a reading            |
| assumptions (purple)      | `cpApproxCv`, `atomicWeightsReliable`, ...               |
| `composed_of`             | a theory is the premise of an `entails` edge             |
| `predicts`                | `entails [theory, auxiliaries] claim`                    |
| `relies_on`               | the auxiliary appears in the premises of the reading edge|
| `reduces_to`              | both theories entail one shared claim under a regime node|
| `forbids`                 | `contradicts`                                            |
| `(suspected)/(discovered)`| tag at the start of the edge's `why`                     |

What goes beyond the model graph:

1. **Limiting regimes are nodes.**  `highTLimit` ("T far above the
   characteristic temperature") and `lowTLimit` are theories.  Einstein and
   Debye each entail the shared claim `latticeCvApproaches3R` under
   `highTLimit`; the classical theory entails it unconditionally.  That is the
   "reduces to" relation without any new edge type, and it can be queried
   (see the guards).  The same regimes separate Einstein from Debye at low T.
2. **Every experiment states what it relies on.**  A reading is reached only
   through a chain that includes the assumptions behind the measurement, for
   example that the measured `C_p` equals the theoretical `C_v`, or that
   atomic weights are right.
3. **Two theories that are not rivals.**  The electron-gas theories are
   combined with the lattice theories, so a verdict is about a *combination*.
   Debye alone fails the low-temperature metal data; Debye plus Sommerfeld does
   not.
4. **A computed scoreboard.**  `scoreboard` and `refutedBy` run the whole graph
   for a set of granted theories and report each experiment as supported,
   refuted or silent.
5. **Independent test.**  The Debye temperature computed from sound speeds is a
   second, independent route to a quantity fitted from heat capacity.

Regime and sample assumptions (`softMetalsAtRoomTAreHighT`, `insulatorBelowTheta`,
`metalBelowTheta`) belong to particular experiments.  Grant the ones that match
the experiment you query, as the guards below do.  The scoreboard worlds grant
all of them at once, which is consistent because no edge forbids it.
-/

namespace Scilib.HeatCapacity

/-! ## Theories -/

/-- Classical solid: atoms are classical oscillators and energy is shared equally. -/
def classicalSolid : Theory where
  statement := "Each atom of a solid is a classical three-dimensional harmonic oscillator and classical equipartition of energy holds."
  sources := ["Dulong and Petit, 1819", "Boltzmann, 1876"]

/-- Einstein: independent quantised oscillators, all with one frequency. -/
def einsteinSolid : Theory where
  statement := "Each atom is an independent quantised harmonic oscillator, and all atoms of a given solid oscillate at the same single frequency."
  sources := ["Einstein, Annalen der Physik, 1907"]

/-- Debye: quantised sound waves up to a cutoff. -/
def debyeSolid : Theory where
  statement := "The vibrations of a solid are quantised sound waves with a continuous spread of frequencies up to a cutoff fixed by the number of atoms."
  sources := ["Debye, Annalen der Physik, 1912"]

/-- Drude: conduction electrons as a classical ideal gas. -/
def drudeElectrons : Theory where
  statement := "The conduction electrons of a metal are a classical ideal gas, each free electron carrying 3/2 k_B of heat capacity."
  sources := ["Drude, 1900"]

/-- Sommerfeld: conduction electrons as a degenerate quantum gas. -/
def sommerfeldElectrons : Theory where
  statement := "The conduction electrons of a metal are a degenerate quantum (Fermi) gas, so only a thin shell of electrons near the Fermi energy can take up heat."
  sources := ["Sommerfeld, 1928"]

/-! ## Limiting regimes (used for "reduces to") -/

/-- Regime: far above the characteristic temperature. -/
def highTLimit : Theory :=
  { statement := "The temperature is far above the characteristic temperature of the solid." }

/-- Regime: far below the characteristic temperature. -/
def lowTLimit : Theory :=
  { statement := "The temperature is far below the characteristic temperature of the solid." }

/-! ## Assumptions that experiments rely on -/

/-- Measured at constant pressure, predicted at constant volume. -/
def cpApproxCv : Theory :=
  { statement := "For a solid the heat capacity at constant pressure is close to the heat capacity at constant volume." }

/-- Dulong and Petit's product uses atomic weights. -/
def atomicWeightsReliable : Theory :=
  { statement := "The atomic weights used to turn specific heats into molar heat capacities are correct." }

/-- The ordinary soft metals sit in the high-temperature regime at room temperature. -/
def softMetalsAtRoomTAreHighT : Theory :=
  { statement := "For the soft metals tested, room temperature is far above their characteristic temperature (a few hundred kelvin or less)." }

/-- Diamond's characteristic temperature is far above room temperature. -/
def diamondThetaHigh : Theory :=
  { statement := "Diamond has stiff bonds and light atoms, so its characteristic temperature is far above room temperature." }

/-- An insulator's heat capacity is only lattice vibrations. -/
def insulatorLatticeOnly : Theory :=
  { statement := "In an electrically insulating crystal the only appreciable heat capacity is from lattice vibrations." }

/-- The insulator was measured well below its characteristic temperature. -/
def insulatorBelowTheta : Theory :=
  { statement := "The insulating crystal was measured at temperatures far below its characteristic temperature." }

/-- The metal was measured well below its characteristic temperature. -/
def metalBelowTheta : Theory :=
  { statement := "The metal was measured at temperatures far below its characteristic temperature." }

/-- Treating a crystal as an isotropic elastic continuum when computing sound speeds. -/
def isotropicElasticContinuum : Theory :=
  { statement := "The crystal can be treated as an isotropic elastic continuum when sound speeds are averaged." }

/-- Electrons add nothing appreciable near room temperature. -/
def electronsInertAtRoomT : Theory :=
  { statement := "Conduction electrons add no appreciable heat capacity to a metal near room temperature." }

/-- Electrons add nothing appreciable at the lowest temperatures. -/
def electronsInertAtLowT : Theory :=
  { statement := "Conduction electrons add no appreciable heat capacity to a metal at the lowest temperatures." }

/-! ## Claims (theory-level, about the theoretical heat capacity) -/

/-- Classical prediction for the lattice. -/
def latticeCvEquals3R : Theory :=
  { statement := "The lattice heat capacity of any solid element is 3R (about 24.9 J/(mol K)) at every temperature." }

/-- The shared limiting claim: classical value reached at high temperature. -/
def latticeCvApproaches3R : Theory :=
  { statement := "The lattice heat capacity approaches 3R (about 24.9 J/(mol K))." }

/-- Quantum prediction: partial freeze-out. -/
def latticePartialFreezeOut : Theory :=
  { statement := "Below its characteristic temperature a solid has a lattice heat capacity below 3R that increases with temperature." }

/-- Quantum prediction: vanishing at low temperature. -/
def latticeCvFallsToZero : Theory :=
  { statement := "The lattice heat capacity falls toward zero as the temperature falls toward zero." }

/-- Einstein prediction at low T. -/
def latticeCvExponentialLowT : Theory :=
  { statement := "At low temperature the lattice heat capacity vanishes exponentially." }

/-- Debye prediction at low T. -/
def latticeCvCubicLowT : Theory :=
  { statement := "At low temperature the lattice heat capacity is proportional to T cubed." }

/-- Drude prediction. -/
def electronsAdd1p5RAtRoomT : Theory :=
  { statement := "Each mole of free electrons adds 3/2 R to the heat capacity at room temperature." }

/-- Sommerfeld prediction. -/
def electronsLinearInTAtLowT : Theory :=
  { statement := "At low temperature the conduction electrons add a heat capacity proportional to T." }

/-! ## Predictions (claims combined with assumptions, one per experiment) -/

/-- Classical prediction for diamond. -/
def classicalDiamondPrediction : Theory :=
  { statement := "The measured molar heat capacity of diamond at room temperature is near 3R." }

/-- Einstein prediction for an insulator at low T. -/
def insulatorExponentialPrediction : Theory :=
  { statement := "The measured heat capacity of an insulating crystal vanishes exponentially at the lowest temperatures." }

/-- Debye plus inert electrons: purely cubic metals. -/
def metalPureCubicPrediction : Theory :=
  { statement := "The measured heat capacity of a metal at the lowest temperatures is purely proportional to T cubed." }

/-- Einstein plus electron gas: linear metals. -/
def metalPureLinearPrediction : Theory :=
  { statement := "The measured heat capacity of a metal at the lowest temperatures is purely proportional to T." }

/-- Drude combined with the lattice: about 4.5R. -/
def metalsNear4p5R : Theory :=
  { statement := "Metals with one free electron per atom have a molar heat capacity near 4.5R (about 37 J/(mol K)) at room temperature." }

/-! ## Readings of the raw records -/

def dpRegularity : Theory :=
  { statement := "At room temperature the product of specific heat and atomic weight is nearly the same for all the elements tested." }

def diamondLowAndRising : Theory :=
  { statement := "The molar heat capacity of diamond is far below 3R at room temperature and rises steadily with temperature." }

def heatCapacityDropsOnCooling : Theory :=
  { statement := "The molar heat capacities of solids fall steadily to a small fraction of their room-temperature value as the temperature is lowered toward about 20 K." }

def insulatorCubicReading : Theory :=
  { statement := "The heat capacity of an insulating crystal at the lowest temperatures is proportional to T cubed." }

def metalCOverTLinearInTSquared : Theory :=
  { statement := "For a metal at the lowest temperatures the heat capacity divided by T is a straight line in T squared with a nonzero intercept." }

def metalsNear3RAtRoomT : Theory :=
  { statement := "Metals, including sodium and potassium, have molar heat capacities of about 24 to 30 J/(mol K) at room temperature, not about 37." }

def thetaFromSoundAgrees : Theory :=
  { statement := "The characteristic temperature fitted to heat-capacity data roughly agrees with the one computed from measured sound speeds." }

/-! ## Raw experiments -/

/-- Raw record: Dulong and Petit. -/
def dulongPetit1819 : Experiment where
  protocol := "Measure the specific heat of a dozen or so solid elements near room temperature and multiply by the accepted atomic weight of each."
  observation := "The products are nearly equal for all the elements."
  sources := ["Dulong and Petit, Annales de chimie et de physique, 1819"]

/-- Raw record: Weber's diamond. -/
def weber1875 : Experiment where
  protocol := "Measure the specific heat of diamond over a wide range of temperature, from below room temperature to several hundred degrees Celsius."
  observation := "The specific heat is far lower than for ordinary metals at room temperature and increases steadily with temperature."
  sources := ["H. F. Weber, 1875"]

/-- Raw record: Nernst and Lindemann. -/
def nernstLindemann1911 : Experiment where
  protocol := "Measure the heat capacity of many solids down to the temperature of liquid hydrogen."
  observation := "The heat capacity of every solid measured falls steadily on cooling to a small fraction of its room-temperature value."
  sources := ["Nernst and Lindemann, 1911"]

/-- Raw record: low-T insulator. -/
def insulatorLowT : Experiment where
  protocol := "Measure the heat capacity of an electrically insulating crystal over a range of temperatures far below its characteristic temperature."
  observation := "Plotted on logarithmic axes the data fall on a straight line of slope 3."

/-- Raw record: low-T metal. -/
def metalLowT : Experiment where
  protocol := "Measure the heat capacity of a pure metal over a range of temperatures below a few kelvin and plot the heat capacity divided by T against T squared."
  observation := "The points fall on a straight line that does not pass through the origin."

/-- Raw record: room-temperature metals. -/
def metalsRoomT : Experiment where
  protocol := "Measure the molar heat capacity near room temperature of metallic elements, including sodium and potassium."
  observation := "All values lie between about 24 and 30 J/(mol K)."

/-- Raw record: sound speed versus heat capacity. -/
def soundVelocity : Experiment where
  protocol := "For several crystals, fit a characteristic temperature to heat-capacity data, and compute one from measured sound speeds and the atomic density."
  observation := "The two characteristic temperatures agree within a few tens of percent."
  sources := ["Debye, 1912"]

/-! ## The graph -/

def evidenceGraph : Graph where
  edges := [
    -- Incompatible claims (forbids)
    Edge.contradicts latticeCvEquals3R latticeCvFallsToZero
      "A constant heat capacity cannot also vanish at low temperature.",
    Edge.contradicts latticeCvEquals3R latticePartialFreezeOut,
    Edge.contradicts latticeCvExponentialLowT latticeCvCubicLowT
      "Einstein and Debye differ only here, in the low-temperature regime.",
    Edge.contradicts drudeElectrons sommerfeldElectrons,
    Edge.contradicts drudeElectrons electronsInertAtRoomT
      "(discovered) The classical electron gas should have shown up at room temperature.",
    Edge.contradicts sommerfeldElectrons electronsInertAtLowT
      "The degenerate gas leaves a term linear in T at the lowest temperatures.",

    -- Theories to claims (predicts)
    Edge.implies classicalSolid latticeCvEquals3R,
    Edge.implies latticeCvEquals3R latticeCvApproaches3R
      "The shared claim: the classical theory has it everywhere.",
    Edge.entails [einsteinSolid, highTLimit] latticeCvApproaches3R
      "Einstein reduces to the classical value as T/theta grows large.",
    Edge.entails [debyeSolid, highTLimit] latticeCvApproaches3R
      "Debye reduces to the classical value as T/theta grows large.",
    Edge.implies einsteinSolid latticeCvFallsToZero,
    Edge.implies debyeSolid latticeCvFallsToZero,
    Edge.implies einsteinSolid latticePartialFreezeOut,
    Edge.implies debyeSolid latticePartialFreezeOut,
    Edge.entails [einsteinSolid, lowTLimit] latticeCvExponentialLowT,
    Edge.entails [debyeSolid, lowTLimit] latticeCvCubicLowT,
    Edge.implies drudeElectrons electronsAdd1p5RAtRoomT,
    Edge.implies sommerfeldElectrons electronsInertAtRoomT
      "Only electrons within about k_B T of the Fermi energy can be excited, a tiny fraction.",
    Edge.implies sommerfeldElectrons electronsLinearInTAtLowT,

    -- Regime assumptions (composed_of)
    Edge.implies softMetalsAtRoomTAreHighT highTLimit
      "(suspected) For some metals the characteristic temperature is near room temperature, so this is only approximate.",
    Edge.implies insulatorBelowTheta lowTLimit,
    Edge.implies metalBelowTheta lowTLimit,

    -- Experiment 1: Dulong and Petit (relies on weights, calorimetry)
    Edge.entails [latticeCvApproaches3R, cpApproxCv, atomicWeightsReliable] dpRegularity
      "relies_on (discovered): atomic weights; the law was later used in reverse to correct them.",
    Edge.interprets dpRegularity dulongPetit1819
      "A product of two measured quantities, normalised by assigned atomic weights.",

    -- Experiment 2: Weber's diamond
    Edge.entails [latticeCvEquals3R, cpApproxCv] classicalDiamondPrediction,
    Edge.contradicts classicalDiamondPrediction diamondLowAndRising,
    Edge.entails [latticePartialFreezeOut, diamondThetaHigh, cpApproxCv] diamondLowAndRising
      "relies_on: diamond being stiff and light; independent evidence for this is its high sound speed.",
    Edge.interprets diamondLowAndRising weber1875,

    -- Experiment 3: Nernst and Lindemann
    Edge.entails [latticeCvFallsToZero, cpApproxCv] heatCapacityDropsOnCooling
      "The qualitative drop does not depend on which theory of the lattice is right.",
    Edge.contradicts latticeCvEquals3R heatCapacityDropsOnCooling,
    Edge.interprets heatCapacityDropsOnCooling nernstLindemann1911,

    -- Experiment 4: insulators at low T (Debye vs Einstein)
    Edge.entails [latticeCvCubicLowT, insulatorLatticeOnly, cpApproxCv] insulatorCubicReading
      "relies_on: no other contribution in an insulator.",
    Edge.entails [latticeCvExponentialLowT, insulatorLatticeOnly, cpApproxCv] insulatorExponentialPrediction,
    Edge.contradicts insulatorExponentialPrediction insulatorCubicReading,
    Edge.contradicts latticeCvEquals3R insulatorCubicReading,
    Edge.interprets insulatorCubicReading insulatorLowT
      "A slope of 3 on a log-log plot is read as a T cubed law.",

    -- Experiment 5: metals at low T (needs the electron term)
    Edge.entails [latticeCvCubicLowT, electronsLinearInTAtLowT, cpApproxCv] metalCOverTLinearInTSquared,
    Edge.entails [latticeCvCubicLowT, electronsInertAtLowT, cpApproxCv] metalPureCubicPrediction,
    Edge.entails [latticeCvExponentialLowT, electronsLinearInTAtLowT, cpApproxCv] metalPureLinearPrediction,
    Edge.contradicts metalPureCubicPrediction metalCOverTLinearInTSquared,
    Edge.contradicts metalPureLinearPrediction metalCOverTLinearInTSquared,
    Edge.contradicts latticeCvEquals3R metalCOverTLinearInTSquared,
    Edge.interprets metalCOverTLinearInTSquared metalLowT
      "Intercept is the electron term, slope the lattice term.",

    -- Experiment 6: metals at room temperature (the electron puzzle)
    Edge.entails [latticeCvApproaches3R, electronsInertAtRoomT, cpApproxCv] metalsNear3RAtRoomT,
    Edge.entails [latticeCvApproaches3R, electronsAdd1p5RAtRoomT, cpApproxCv] metalsNear4p5R,
    Edge.contradicts metalsNear4p5R metalsNear3RAtRoomT,
    Edge.interprets metalsNear3RAtRoomT metalsRoomT,

    -- Experiment 7: independent route to the characteristic temperature
    Edge.entails [debyeSolid, isotropicElasticContinuum, cpApproxCv] thetaFromSoundAgrees
      "(suspected) relies_on: isotropy, which real crystals only approximate.  Einstein makes no such prediction.",
    Edge.interprets thetaFromSoundAgrees soundVelocity
  ]

/-! ## Analysis -/

/-- Experiments with a short name. -/
def experiments : List (String × Experiment) :=
  [ ("DulongPetit1819", dulongPetit1819),
    ("Weber1875", weber1875),
    ("NernstLindemann1911", nernstLindemann1911),
    ("InsulatorLowT", insulatorLowT),
    ("MetalLowT", metalLowT),
    ("MetalsRoomT", metalsRoomT),
    ("SoundVelocity", soundVelocity) ]

/-- What a set of granted theories says about one experiment. -/
def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

/-- The verdict of a world on every experiment. -/
def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

/-- Names of the experiments that refute the world. -/
def refutedBy (world : List Theory) : List String :=
  experiments.filterMap fun (name, e) =>
    if evidenceGraph.refutes world e then some name else none

/-- What a reading relies on: each premise set that would justify it. -/
def reliesOn (reading : Theory) : List (List String) :=
  (evidenceGraph.justifications reading).map fun ps => ps.map (·.statement)

/-- Assumptions granted in every world below. -/
def commonAux : List Theory :=
  [ cpApproxCv, atomicWeightsReliable, softMetalsAtRoomTAreHighT, diamondThetaHigh,
    insulatorLatticeOnly, insulatorBelowTheta, metalBelowTheta, isotropicElasticContinuum ]

def worldClassical : List Theory :=
  [classicalSolid, electronsInertAtRoomT, electronsInertAtLowT] ++ commonAux

def worldClassicalDrude : List Theory :=
  [classicalSolid, drudeElectrons, electronsInertAtLowT] ++ commonAux

def worldEinsteinSommerfeld : List Theory :=
  [einsteinSolid, sommerfeldElectrons] ++ commonAux

def worldDebyeSommerfeld : List Theory :=
  [debyeSolid, sommerfeldElectrons] ++ commonAux

def worldDebyeNoElectrons : List Theory :=
  [debyeSolid, electronsInertAtRoomT, electronsInertAtLowT] ++ commonAux

#eval scoreboard worldClassical
#eval scoreboard worldClassicalDrude
#eval scoreboard worldEinsteinSommerfeld
#eval scoreboard worldDebyeSommerfeld
#eval scoreboard worldDebyeNoElectrons
#eval reliesOn dpRegularity

/-! ## Checks (they fail at compile time if the graph disagrees with the history) -/

#guard evidenceGraph.wellFormed

-- Rivalries are computed from claims, not declared directly.
#guard evidenceGraph.exclusive classicalSolid einsteinSolid
#guard evidenceGraph.exclusive classicalSolid debyeSolid
#guard evidenceGraph.exclusive drudeElectrons sommerfeldElectrons
-- Einstein and Debye agree except in the low-temperature regime.
#guard !evidenceGraph.exclusive einsteinSolid debyeSolid
#guard evidenceGraph.inconsistent [einsteinSolid, debyeSolid, lowTLimit]

-- "Reduces to": both quantum theories give the classical value in the high-T limit,
-- but only once the regime is granted.
#guard (evidenceGraph.derive [classicalSolid]).contains latticeCvApproaches3R
#guard (evidenceGraph.derive [einsteinSolid, highTLimit]).contains latticeCvApproaches3R
#guard (evidenceGraph.derive [debyeSolid, highTLimit]).contains latticeCvApproaches3R
#guard !(evidenceGraph.derive [debyeSolid]).contains latticeCvApproaches3R

-- Experiment 1: Dulong and Petit.
#guard evidenceGraph.supports [classicalSolid, cpApproxCv, atomicWeightsReliable] dulongPetit1819
#guard evidenceGraph.supports [debyeSolid, softMetalsAtRoomTAreHighT, cpApproxCv, atomicWeightsReliable] dulongPetit1819
#guard !evidenceGraph.supports [debyeSolid, cpApproxCv, atomicWeightsReliable] dulongPetit1819
#guard !evidenceGraph.supports [classicalSolid, cpApproxCv] dulongPetit1819

-- Experiment 2: diamond refutes the classical theory, supports both quantum ones.
#guard evidenceGraph.refutes [classicalSolid, cpApproxCv] weber1875
#guard evidenceGraph.supports [einsteinSolid, diamondThetaHigh, cpApproxCv] weber1875
#guard evidenceGraph.supports [debyeSolid, diamondThetaHigh, cpApproxCv] weber1875

-- Experiment 3: the drop on cooling.
#guard evidenceGraph.refutes [classicalSolid, cpApproxCv] nernstLindemann1911
#guard evidenceGraph.supports [einsteinSolid, cpApproxCv] nernstLindemann1911
#guard evidenceGraph.supports [debyeSolid, cpApproxCv] nernstLindemann1911

-- Experiment 4: Debye beats Einstein, but only inside the low-T regime.
#guard evidenceGraph.refutes [einsteinSolid, insulatorBelowTheta, insulatorLatticeOnly, cpApproxCv] insulatorLowT
#guard evidenceGraph.supports [debyeSolid, insulatorBelowTheta, insulatorLatticeOnly, cpApproxCv] insulatorLowT
#guard !evidenceGraph.refutes [einsteinSolid, cpApproxCv] insulatorLowT

-- Experiment 5: Debye needs the electron term; Einstein is refuted even with it.
#guard evidenceGraph.supports [debyeSolid, sommerfeldElectrons, metalBelowTheta, cpApproxCv] metalLowT
#guard evidenceGraph.refutes [debyeSolid, electronsInertAtLowT, metalBelowTheta, cpApproxCv] metalLowT
#guard evidenceGraph.refutes [einsteinSolid, sommerfeldElectrons, metalBelowTheta, cpApproxCv] metalLowT

-- Experiment 6: the classical electron gas fails at room temperature.
#guard evidenceGraph.refutes [classicalSolid, drudeElectrons, cpApproxCv] metalsRoomT
#guard evidenceGraph.refutes [debyeSolid, drudeElectrons, softMetalsAtRoomTAreHighT, cpApproxCv] metalsRoomT
#guard evidenceGraph.supports [classicalSolid, electronsInertAtRoomT, cpApproxCv] metalsRoomT
#guard evidenceGraph.supports [debyeSolid, sommerfeldElectrons, softMetalsAtRoomTAreHighT, cpApproxCv] metalsRoomT

-- Experiment 7: only Debye has a stake.
#guard evidenceGraph.supports [debyeSolid, isotropicElasticContinuum, cpApproxCv] soundVelocity
#guard !evidenceGraph.supports [einsteinSolid, isotropicElasticContinuum, cpApproxCv] soundVelocity
#guard !evidenceGraph.refutes [einsteinSolid, isotropicElasticContinuum, cpApproxCv] soundVelocity

-- The whole story as a scoreboard: exactly one world survives everything.
#guard refutedBy worldClassical ==
  ["Weber1875", "NernstLindemann1911", "InsulatorLowT", "MetalLowT"]
#guard refutedBy worldClassicalDrude ==
  ["Weber1875", "NernstLindemann1911", "InsulatorLowT", "MetalLowT", "MetalsRoomT"]
#guard refutedBy worldEinsteinSommerfeld == ["InsulatorLowT", "MetalLowT"]
#guard refutedBy worldDebyeNoElectrons == ["MetalLowT"]
#guard refutedBy worldDebyeSommerfeld == []

end Scilib.HeatCapacity
