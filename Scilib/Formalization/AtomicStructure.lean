module

public import Physlib.QuantumMechanics.Hydrogen.Rydberg
public import Physlib.Electromagnetism.Charge.ChargeUnit
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Arctan
public import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# Formal readings of AtomicStructure

Hydrogen energies and transition frequencies reuse PhysLib. Their identification
with the Hamiltonian's point spectrum is explicitly not proved in PhysLib.
The local Bohr model adds radius and angular-momentum formulas; it does not
construct quantum eigenstates or solve classical electron orbits.

Charge distributions, apparatus conditions, Rutherford deflection, and mercury
excitation are local models. No hydrogen theorem is used to assert mercury
excitation or cathode-ray measurements. Thresholds and tolerances are explicit
inputs in consistent units, not estimates of historical experimental uncertainty.

`DiscreteSpectralLines` means frequencies drawn from a countably indexed
transition family, not a topologically discrete set: spectral series accumulate.
The graph's existing edges are unchanged and are not certified by this module.
See `AtomicStructure.md` for the node-by-node correspondence.
-/

@[expose] public noncomputable section
namespace Scilib.Formalization.AtomicStructure

open Real MeasureTheory QuantumMechanics
open scoped BigOperators

abbrev Vector := EuclideanSpace ℝ (Fin 3)

def elementaryCharge : ℝ := ChargeUnit.elementaryCharge.val

theorem elementaryCharge_pos : 0 < elementaryCharge := ChargeUnit.elementaryCharge.property

structure CathodeData (Material : Type) where
  charge : Material → ℝ
  mass : Material → ℝ
  atomicMass : Material → ℝ
  emissionRate : Material → ℝ

/-- Material-independent negative electron charge and common subatomic mass.
`Material` is the specified class of emitting materials, not proof of occurrence
in every material in nature. -/
def SubatomicElectronTheory (d : CathodeData Material) (electronMass : ℝ) : Prop :=
  Nonempty Material ∧ 0 < electronMass ∧
  ∀ material, d.charge material = -elementaryCharge ∧
    d.mass material = electronMass ∧ electronMass < d.atomicMass material ∧
    0 < d.emissionRate material

/-- Magnitude of the specific charge, with an explicit reference value and
dimensionless lower-bound factor making "high" relative rather than arbitrary. -/
def UniversalChargeToMassRatio (d : CathodeData Material)
    (referenceRatio highFactor : ℝ) : Prop :=
  Nonempty Material ∧ 0 < referenceRatio ∧ 1 < highFactor ∧
  (∀ material, 0 < d.mass material ∧ d.charge material < 0 ∧
    highFactor * referenceRatio ≤ |d.charge material| / d.mass material) ∧
  ∀ a b, |d.charge a| / d.mass a = |d.charge b| / d.mass b

theorem electron_specific_charge (d : CathodeData Material) (m : ℝ)
    (h : SubatomicElectronTheory d m) (a : Material) :
    |d.charge a| / d.mass a = elementaryCharge / m := by
  rw [(h.2.2 a).1, (h.2.2 a).2.1, abs_neg, abs_of_pos elementaryCharge_pos]

theorem electron_ratio_universal (d : CathodeData Material) (m : ℝ)
    (h : SubatomicElectronTheory d m) (reference factor : ℝ)
    (hr : 0 < reference) (hf : 1 < factor)
    (hhigh : factor * reference ≤ elementaryCharge / m) :
    UniversalChargeToMassRatio d reference factor := by
  refine ⟨h.1, hr, hf, ?_, ?_⟩
  · intro a
    refine ⟨?_, ?_, ?_⟩
    · rw [(h.2.2 a).2.1]; exact h.2.1
    · rw [(h.2.2 a).1]; exact neg_neg_of_pos elementaryCharge_pos
    · rw [electron_specific_charge d m h a]; exact hhigh
  · intro a b
    rw [electron_specific_charge d m h a, electron_specific_charge d m h b]

structure Electron where
  position : Vector
  charge : ℝ

structure AtomData where
  radius : ℝ
  positiveCharge : ℝ
  totalMass : ℝ
  positiveDensity : Vector → ℝ
  massDensity : Vector → ℝ
  electrons : List Electron

/-- A neutral ideal plum-pudding atom, including the normalization of the
positive charge density. Integrals use ordinary Euclidean volume. -/
def ThomsonModel (a : AtomData) : Prop :=
  0 < a.radius ∧ 0 < a.positiveCharge ∧
  (∀ x, a.positiveDensity x = if ‖x‖ ≤ a.radius then
    a.positiveCharge / ((4 / 3 : ℝ) * π * a.radius^3) else 0) ∧
  Integrable a.positiveDensity ∧ (∫ x, a.positiveDensity x) = a.positiveCharge ∧
  a.electrons ≠ [] ∧
  (∀ e ∈ a.electrons, ‖e.position‖ ≤ a.radius ∧ e.charge = -elementaryCharge) ∧
  (a.electrons.map (·.charge)).sum = -a.positiveCharge

/-- Charge and nearly all mass lie within a small central ball. Size and
concentration fractions are explicit parameters, with values strictly below one. -/
def RutherfordModel (a : AtomData) (nuclearRadius sizeRatio missingMassFraction : ℝ) : Prop :=
  0 < a.radius ∧ 0 < a.positiveCharge ∧ 0 < a.totalMass ∧
  0 < nuclearRadius ∧ 0 < sizeRatio ∧ sizeRatio < 1 ∧
  nuclearRadius ≤ sizeRatio * a.radius ∧
  0 ≤ missingMassFraction ∧ missingMassFraction < 1 ∧
  Integrable a.positiveDensity ∧ Integrable a.massDensity ∧
  (∀ x, 0 ≤ a.positiveDensity x ∧ 0 ≤ a.massDensity x) ∧
  (∫ x, a.positiveDensity x) = a.positiveCharge ∧
  (∫ x, a.massDensity x) = a.totalMass ∧
  (∀ x, nuclearRadius < ‖x‖ → a.positiveDensity x = 0) ∧
  (1 - missingMassFraction) * a.totalMass ≤
    ∫ x in Metric.closedBall (0 : Vector) nuclearRadius, a.massDensity x

/-- A stationary hydrogenic level scheme with the Bohr circular-radius and
angular-momentum formulas. It is not a theorem about hydrogen eigenfunctions. -/
def BohrModel (H : HydrogenAtom) (energy radius angularMomentum : ℕ → ℝ) : Prop :=
  H.d = 3 ∧ 0 < H.k ∧ ∀ n,
    energy n = H.energyLevel n ∧
    radius n = (Constants.ℏ : ℝ)^2 * ((n : ℝ) + 1)^2 / (H.m * H.k) ∧
    angularMomentum n = ((n : ℝ) + 1) * (Constants.ℏ : ℝ)

theorem bohr_energy_ordered (H : HydrogenAtom) (E r L : ℕ → ℝ)
    (h : BohrModel H E r L) : StrictMono E := by
  have hd := h.1
  intro i j hij
  rw [(h.2.2 i).1, (h.2.2 j).1]
  exact H.energyLevel_strictMono (by omega) (ne_of_gt h.2.1) hij

inductive Gas where
  | hydrogen | mercury | other
  deriving DecidableEq

structure TubeData where
  gas : Gas
  pressure : ℝ
  voltage : ℝ
  electrodeGap : ℝ
  electricFieldMagnitude : ℝ
  sourceTemperature : ℝ
  requestedEnergy : ℕ → ℝ
  incidentEnergy : ℕ → ℝ

def VacuumCathodeTube (t : TubeData) (lowPressureLimit highVoltageThreshold : ℝ) : Prop :=
  0 < t.pressure ∧ t.pressure ≤ lowPressureLimit ∧ 0 < lowPressureLimit ∧
  0 < highVoltageThreshold ∧ highVoltageThreshold ≤ t.voltage ∧
  0 < t.electrodeGap ∧ t.electricFieldMagnitude = t.voltage / t.electrodeGap

structure AlphaBeamData where
  protons : ℕ
  neutrons : ℕ
  boundElectrons : ℕ
  charge : ℝ
  mass : ℝ
  kineticEnergy : ℝ

def AlphaParticleBeam (b : AlphaBeamData) (highEnergyThreshold : ℝ) : Prop :=
  b.protons = 2 ∧ b.neutrons = 2 ∧ b.boundElectrons = 0 ∧
  b.charge = 2 * elementaryCharge ∧ 0 < b.mass ∧
  0 < highEnergyThreshold ∧ highEnergyThreshold ≤ b.kineticEnergy

def MercuryVaporTube (t : TubeData) (lowPressureLimit emissionTemperature energyTolerance : ℝ)
    (settings : Set ℕ) : Prop :=
  t.gas = .mercury ∧ 0 < t.pressure ∧ t.pressure ≤ lowPressureLimit ∧
  0 < emissionTemperature ∧ emissionTemperature ≤ t.sourceTemperature ∧
  0 ≤ energyTolerance ∧ settings.Nonempty ∧
  ∀ i ∈ settings, 0 ≤ t.requestedEnergy i ∧ 0 ≤ t.incidentEnergy i ∧
    |t.incidentEnergy i - t.requestedEnergy i| ≤ energyTolerance

def HydrogenDischargeTube (t : TubeData) (lowPressureLimit : ℝ) : Prop :=
  t.gas = .hydrogen ∧ 0 < t.pressure ∧ t.pressure ≤ lowPressureLimit ∧
  0 < t.voltage ∧ 0 < t.electrodeGap ∧
  t.electricFieldMagnitude = t.voltage / t.electrodeGap

structure ScatteringData where
  impactParameters : Set ℝ
  deflection : ℝ → ℝ

def SmallAngleScatteringOnly (s : ScatteringData) (smallAngleBound : ℝ) : Prop :=
  s.impactParameters.Nonempty ∧ 0 ≤ smallAngleBound ∧ smallAngleBound < π / 2 ∧
  ∀ b ∈ s.impactParameters, 0 < b ∧ 0 ≤ s.deflection b ∧ s.deflection b ≤ smallAngleBound

/-- Heavy-target, repulsive point-Coulomb kinematic model. The deflection formula
is assumed, not derived from an ODE or from the nuclear density predicate. -/
def RutherfordScatteringLaw (s : ScatteringData) (coupling energy : ℝ) : Prop :=
  0 < coupling ∧ 0 < energy ∧
  ∀ b ∈ s.impactParameters, 0 < b ∧
    s.deflection b = 2 * arctan (coupling / (2 * energy * b))

def LargeAngleBackscattering (s : ScatteringData) (coupling energy
    targetMass projectileMass heavyTargetFactor : ℝ) : Prop :=
  RutherfordScatteringLaw s coupling energy ∧
  0 < projectileMass ∧ 1 < heavyTargetFactor ∧ heavyTargetFactor * projectileMass ≤ targetMass ∧
  ∃ b ∈ s.impactParameters, π / 2 < s.deflection b ∧ s.deflection b < π

theorem rutherford_large_deflection (s : ScatteringData) (k E b : ℝ)
    (h : RutherfordScatteringLaw s k E) (hb : b ∈ s.impactParameters)
    (hclose : 2 * E * b < k) : π / 2 < s.deflection b := by
  have hpos : 0 < 2 * E * b := mul_pos (mul_pos (by norm_num) h.2.1) (h.2.2 b hb).1
  have hratio : (1 : ℝ) < k / (2 * E * b) := (lt_div_iff₀ hpos).2 (by simpa using hclose)
  have ha := Real.arctan_strictMono hratio
  rw [Real.arctan_one] at ha
  rw [(h.2.2 b hb).2]
  linarith

theorem rutherford_backscattering (s : ScatteringData) (k E M m factor b : ℝ)
    (h : RutherfordScatteringLaw s k E) (hm : 0 < m) (hf : 1 < factor)
    (hheavy : factor * m ≤ M) (hb : b ∈ s.impactParameters)
    (hclose : 2 * E * b < k) : LargeAngleBackscattering s k E M m factor := by
  refine ⟨h, hm, hf, hheavy, b, hb, rutherford_large_deflection s k E b h hb hclose, ?_⟩
  rw [(h.2.2 b hb).2]
  linarith [Real.arctan_lt_pi_div_two (k / (2 * E * b))]

theorem small_large_incompatible (s : ScatteringData) (bound k E M m factor : ℝ)
    (hs : SmallAngleScatteringOnly s bound)
    (hl : LargeAngleBackscattering s k E M m factor) : False := by
  obtain ⟨b, hb, hwide, hupper⟩ := hl.2.2.2.2
  have hsmall := (hs.2.2.2 b hb).2.2
  linarith [hs.2.2.1]

/-- A separate excitation-level and current-threshold model, usable for mercury.
The current drop is a supplied one-sided-limit condition, not derived transport. -/
def DiscreteEnergyTransfer (levels : ℕ → ℝ) (transfers : Set ℝ)
    (current : ℝ → ℝ) (thresholds : Set ℝ) (dropBound : ℝ) : Prop :=
  StrictMono levels ∧ transfers.Nonempty ∧
  (∀ loss ∈ transfers, ∃ i j : ℕ, i < j ∧ loss = levels j - levels i) ∧
  0 < dropBound ∧ thresholds.Nonempty ∧
  (∀ loss ∈ transfers, ∃ V ∈ thresholds, elementaryCharge * V = loss) ∧
  (∀ V ∈ thresholds, 0 < V ∧ ∃ loss ∈ transfers, elementaryCharge * V = loss) ∧
  ∀ V ∈ thresholds, ∃ left right : ℝ,
    Filter.Tendsto current (nhdsWithin V (Set.Iio V)) (nhds left) ∧
    Filter.Tendsto current (nhdsWithin V (Set.Ioi V)) (nhds right) ∧ right + dropBound ≤ left

def emissionFrequencies (H : HydrogenAtom) : Set ℝ :=
  {ν | ∃ lower upper : ℕ, lower < upper ∧ ν = H.transitionFrequency lower upper}

def DiscreteSpectralLines (H : HydrogenAtom) (frequencies : Set ℝ) : Prop :=
  H.d = 3 ∧ 0 < H.k ∧ frequencies.Nonempty ∧ frequencies ⊆ emissionFrequencies H

def frequenciesFromLevels (energy : ℕ → ℝ) : Set ℝ :=
  {ν | ∃ lower upper : ℕ, lower < upper ∧
    ν = (energy upper - energy lower) / (Constants.h : ℝ)}

theorem bohr_to_spectral_lines (H : HydrogenAtom) (E r L : ℕ → ℝ)
    (h : BohrModel H E r L) : DiscreteSpectralLines H (frequenciesFromLevels E) := by
  refine ⟨h.1, h.2.1, ?_, ?_⟩
  · exact ⟨(E 1 - E 0) / (Constants.h : ℝ), 0, 1, by decide, rfl⟩
  · rintro ν ⟨i, j, hij, hν⟩
    refine ⟨i, j, hij, ?_⟩
    rw [hν, (h.2.2 i).1, (h.2.2 j).1]
    rfl

theorem spectral_frequency_positive (H : HydrogenAtom) (frequencies : Set ℝ)
    (h : DiscreteSpectralLines H frequencies) {ν : ℝ} (hν : ν ∈ frequencies) : 0 < ν := by
  have hd := h.1
  obtain ⟨i, j, hij, rfl⟩ := h.2.2.2 hν
  exact H.transitionFrequency_pos (by omega) (ne_of_gt h.2.1) hij

theorem emissionFrequencies_countable (H : HydrogenAtom) : (emissionFrequencies H).Countable := by
  apply (Set.countable_range (fun ij : ℕ × ℕ => H.transitionFrequency ij.1 ij.2)).mono
  rintro ν ⟨i, j, hij, hν⟩
  exact ⟨(i, j), hν.symm⟩

theorem spectral_frequencies_countable (H : HydrogenAtom) (frequencies : Set ℝ)
    (h : DiscreteSpectralLines H frequencies) : frequencies.Countable :=
  (emissionFrequencies_countable H).mono h.2.2.2

theorem photon_energy_balance (H : HydrogenAtom) (lower upper : ℕ) :
    (Constants.h : ℝ) * H.transitionFrequency lower upper =
      H.energyLevel upper - H.energyLevel lower := by
  rw [HydrogenAtom.transitionFrequency_eq_div, HydrogenAtom.transitionEnergy_eq_sub]
  field_simp

/-- PhysLib uses zero-based level indices, so its lower index `1` is the
physical principal quantum number `2` of the Balmer series. -/
theorem balmer_formula (H : HydrogenAtom) (hd : H.d = 3) (upper : ℕ) :
    H.balmerFrequency upper = H.rydbergFrequency *
      (1 / 4 - 1 / ((upper : ℝ) + 1)^2) := by
  have h := H.transitionFrequency_eq 1 upper
  norm_num [HydrogenAtom.levelIndex, hd] at h
  simpa only [one_div] using h

theorem balmer_lines_distinct (H : HydrogenAtom) (hd : H.d = 3) (hk : 0 < H.k)
    {i j : ℕ} (hij : i < j) : H.balmerFrequency i < H.balmerFrequency j :=
  H.transitionFrequency_strictMono (by omega) (ne_of_gt hk) 1 hij

end Scilib.Formalization.AtomicStructure
