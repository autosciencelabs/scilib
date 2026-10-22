import Basic

namespace Scilib.AtomicStructure

open Scilib

/-! ## Lab State & Domain Instruments -/

structure AtomicLabState where
  voltageKV : Float := 0.0
  alphaEmitted : Nat := 0
  /-- alphas detected scattered past 90 degrees -/
  backscattered : Nat := 0
  /-- accelerating potential in tenths of a volt, so 49 means 4.9 V -/
  mercuryVoltageDeciV : Nat := 0
  /-- sweep points (tenths of a volt) at which the collector current dropped -/
  currentMinimaDeciV : List Nat := []
  spectrometerWavelengthNm : Float := 0.0
  log : List String := []
  deriving Repr

abbrev LabM := StateT AtomicLabState (Except String)
abbrev Experiment := LabM Unit

def senseAtomic {α : Type} (s : Sensor AtomicLabState α) : LabM α := do
  let val ← sense s
  modify fun state => { state with log := state.log ++ [s.name ++ " reading captured"] }
  pure val

def actuateAtomic {α : Type} (a : Actuator AtomicLabState α) (cmd : α) : LabM Unit := do
  let st ← get
  match a.apply cmd st with
  | .ok nextState => set nextState
  | .error msg => throw msg


/-! ## Historical Instruments & Calibration -/

def emRatioSensor : Sensor AtomicLabState Float := {
  name := "Thomson CRT e/m Meter"
  read := fun _ => 1.7e11
}

def backscatterSensor : Sensor AtomicLabState Nat := {
  name := "ZnS Scintillation Microscope"
  read := fun st => st.backscattered
}

def franckHertzCurrentSensor : Sensor AtomicLabState Float := {
  name := "Collector Current Ammeter (relative units)"
  read := fun st =>
    if st.mercuryVoltageDeciV > 0 ∧ st.mercuryVoltageDeciV % 49 = 0 then 0.05 else 1.0
}

def spectrometerSensor : Sensor AtomicLabState Float := {
  name := "Diffraction Grating Spectrometer (Angstrom-style)"
  read := fun _ => 656.3
}

def highVoltageActuator : Actuator AtomicLabState Float := {
  name := "Anode Potential Power Supply"
  apply := fun kv st => .ok { st with voltageKV := kv, log := st.log ++ [s!"Set tube accelerating voltage to {kv} kV"] }
}

def alphaSourceActuator : Actuator AtomicLabState Nat := {
  name := "Radium Alpha Source"
  apply := fun count st => .ok { st with
    alphaEmitted := count
    backscattered := count / 8000
    log := st.log ++ [s!"Directed {count} alpha particles at platinum foil"] }
}

def mercurySweepActuator : Actuator AtomicLabState Nat := {
  name := "Mercury Vapor Voltage Sweep"
  apply := fun v st => .ok { st with
    mercuryVoltageDeciV := v
    log := st.log ++ [s!"Applied accelerating potential {v / 10}.{v % 10} V across mercury vapor"] }
}

def hydrogenDischargeActuator : Actuator AtomicLabState Unit := {
  name := "Hydrogen Discharge Tube"
  apply := fun _ st => .ok { st with spectrometerWavelengthNm := 656.3, log := st.log ++ ["Excited hydrogen gas discharge tube"] }
}


/-! ## Executable Historical Experiments -/

def jjThomson1897Run : Experiment := do
  actuateAtomic highVoltageActuator 1.2
  let emRatio ← senseAtomic emRatioSensor
  modify fun st => { st with log := st.log ++ [s!"Derived e/m = {emRatio} C/kg (about 1700 times the hydrogen ion value)"] }

def geigerMarsden1909Run : Experiment := do
  actuateAtomic alphaSourceActuator 16000
  let wideAngleCount ← senseAtomic backscatterSensor
  let st ← get
  modify fun s => { s with log := s.log ++ [s!"Detected {wideAngleCount} of {st.alphaEmitted} alphas scattered past 90 deg (about 1 in 8000)"] }

def franckHertz1914Run : Experiment := do
  for v in [20, 49, 70, 98, 120, 147, 160] do
    actuateAtomic mercurySweepActuator v
    let current ← senseAtomic franckHertzCurrentSensor
    if current < 0.5 then
      modify fun st => { st with
        currentMinimaDeciV := st.currentMinimaDeciV ++ [v]
        log := st.log ++ [s!"Collector current drops at {v / 10}.{v % 10} V"] }

def balmerHAlphaRun : Experiment := do
  actuateAtomic hydrogenDischargeActuator ()
  let wavelength ← senseAtomic spectrometerSensor
  modify fun st => { st with log := st.log ++ [s!"Measured H-alpha at {wavelength} nm (Balmer fitted Angstrom's four lines in 1885)"] }


/-! ## Theoretical Claims & Evidence Graph Connection -/

def subatomicElectronTheory : Theory :=
  { statement := "Cathode rays consist of universal subatomic negatively charged corpuscles."
    sources := ["J.J. Thomson, 1897"] }

def thomsonModel : Theory :=
  { statement := "Thomson plum-pudding model (the nickname is retrospective): a uniform positive sphere with embedded electrons."
    sources := ["J.J. Thomson, 1904"] }

def rutherfordModel : Theory :=
  { statement := "Rutherford Nuclear Model: positive charge and mass concentrated in a tiny nucleus."
    sources := ["E. Rutherford, 1911"] }

def bohrModel : Theory :=
  { statement := "Bohr Quantized Model: electrons occupy discrete stationary states."
    sources := ["N. Bohr, 1913"] }

def universalChargeToMassRatio : Theory :=
  { statement := "Emitted corpuscles show a constant, high charge-to-mass ratio (about 1.7e11 C/kg) for every gas and cathode." }

def smallAngleScatteringOnly : Theory :=
  { statement := "Alpha particles are deflected only by small angles; even compounded multiple scattering makes a deflection past 90 degrees vanishingly improbable (far rarer than 1 in 8000)." }

def largeAngleBackscattering : Theory :=
  { statement := "A small but measurable fraction (about 1 in 8000 on platinum) of alpha particles is deflected past 90 degrees by Coulomb repulsion from a compact massive nucleus." }

def discreteEnergyTransfer : Theory :=
  { statement := "Electrons transfer energy to atoms only in discrete packets of 4.9 eV, so current drops recur at 4.9, 9.8 and 14.7 V." }

def discreteSpectralLines : Theory :=
  { statement := "Hydrogen emits discrete wavelengths (H-alpha at 656.3 nm) that follow the Balmer formula; Bohr's frequency condition reproduces them." }

def jjThomson1897Expr : Theory :=
  { statement := "JJThomson1897: cathode rays show a universal e/m about 1700 times the hydrogen ion's."
    sources := ["J.J. Thomson, 1897"] }

def geigerMarsden1909Expr : Theory :=
  { statement := "GeigerMarsden1909: about 1 in 8000 alphas on platinum foil are deflected past 90 degrees."
    sources := ["H. Geiger and E. Marsden, 1909"] }

def franckHertz1914Expr : Theory :=
  { statement := "FranckHertz1914: collector current drops at 4.9 V intervals in mercury vapor."
    sources := ["J. Franck and G. Hertz, 1914"] }

def balmerFit1885Expr : Theory :=
  { statement := "BalmerFit1885: Balmer's formula fits Angstrom's measured hydrogen lines, including H-alpha at 656.3 nm."
    sources := ["A.J. Angstrom, 1868-1871 (measurements)", "J.J. Balmer, 1885 (formula)"] }

def evidenceGraph : Graph := {
  edges := [
    Edge.implies subatomicElectronTheory universalChargeToMassRatio,
    Edge.interprets universalChargeToMassRatio jjThomson1897Expr
      "Deflection in electric and magnetic fields gave the same e/m for different gases and cathodes.",

    Edge.implies thomsonModel smallAngleScatteringOnly,
    Edge.contradicts smallAngleScatteringOnly largeAngleBackscattering
      "Statistical, not strictly logical: the plum-pudding model makes deflection past 90 degrees vanishingly improbable.",
    Edge.implies rutherfordModel largeAngleBackscattering,
    Edge.interprets largeAngleBackscattering geigerMarsden1909Expr
      "Rutherford (1911) explained the rare large-angle events; Geiger and Marsden (1913) tested the scattering law.",

    Edge.implies bohrModel discreteEnergyTransfer,
    Edge.implies bohrModel discreteSpectralLines,
    Edge.interprets discreteEnergyTransfer franckHertz1914Expr
      "Retrospective reading: Franck and Hertz took 4.9 V as an ionization potential; Bohr (1915) read it as excitation.",
    Edge.interprets discreteSpectralLines balmerFit1885Expr
      "Accommodation, not prediction: the Balmer formula predates Bohr by about 28 years and Bohr derived its constants."
  ]
}

def worldThomson : List Theory := [
  subatomicElectronTheory,
  thomsonModel
]

def worldNuclearBohr : List Theory := [
  subatomicElectronTheory,
  rutherfordModel,
  bohrModel
]

def experiments : List (String × Theory) :=
  [ ("JJThomson1897", jjThomson1897Expr),
    ("GeigerMarsden1909", geigerMarsden1909Expr),
    ("FranckHertz1914", franckHertz1914Expr),
    ("BalmerFit1885", balmerFit1885Expr) ]

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, evidenceGraph.verdict world e)

def runState (e : Experiment) : Option AtomicLabState :=
  match e.run {} with
  | .ok (_, st) => some st
  | .error _ => none


/-! ## Execution and Verification -/

#eval scoreboard worldThomson
#eval scoreboard worldNuclearBohr

#eval (runState jjThomson1897Run).map (·.log)
#eval (runState geigerMarsden1909Run).map (·.log)
#eval (runState franckHertz1914Run).map (·.log)
#eval (runState balmerHAlphaRun).map (·.log)

-- graph: the Nuclear + Bohr world supports every experiment
#guard evidenceGraph.supports worldNuclearBohr jjThomson1897Expr
#guard evidenceGraph.supports worldNuclearBohr geigerMarsden1909Expr
#guard evidenceGraph.supports worldNuclearBohr franckHertz1914Expr
#guard evidenceGraph.supports worldNuclearBohr balmerFit1885Expr
#guard !(evidenceGraph.refutes worldNuclearBohr geigerMarsden1909Expr)

-- graph: the Thomson world supports the electron result and is refuted by Geiger-Marsden
#guard evidenceGraph.supports worldThomson jjThomson1897Expr
#guard evidenceGraph.refutes worldThomson geigerMarsden1909Expr
#guard !(evidenceGraph.supports worldThomson geigerMarsden1909Expr)
#guard !(evidenceGraph.supports worldThomson franckHertz1914Expr)

-- simulation: the encoded figures match the observations the graph cites
#guard (runState geigerMarsden1909Run).any fun st =>
  st.alphaEmitted == 16000 && st.backscattered == 2
#guard (runState franckHertz1914Run).any fun st =>
  st.currentMinimaDeciV == [49, 98, 147]

end Scilib.AtomicStructure
