import Physlib.FluidDynamics.ThermodynamicCauchyFlow.Bernoulli
import Physlib.FluidDynamics.FluidFlow.Continuity
import Physlib.FluidDynamics.FluidFlow.Incompressible
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Mathematical readings of the Bernoulli example

These predicates specify models and assertions, not their empirical truth. In particular,
the high-speed and high-angle idealizations are deliberately rival assumptions. PhysLib
supplies the fluid fields and specific Bernoulli energy; it does not prove the streamline
law here. Pressure is additional constitutive data, not a field of `CauchyFlow`.

The pressure-drop and Venturi proofs require equal gravitational potential, positive
constant density, and ordered speeds/areas. The existing graph omits some of these
hypotheses, so its edges are not certified by these proofs. A name in `formal` remains
an inspectable reference, not an enforced interpretation of a graph node.

Real time parameters below are implementation coordinates, converted to PhysLib `Time`.
All quantities use consistent units. Relative tolerances are dimensionless; absolute
lift and flow tolerances have their respective measurement units. Tolerances are input
parameters, not estimates of experimental uncertainty. The lift and separation models
below do not derive boundary-layer dynamics from Navier–Stokes.
-/

noncomputable section
namespace Scilib.Formalization.Bernoulli

open FluidDynamics

abbrev Position := Space 3

structure FlowData where
  flow : ThermodynamicCauchyFlow 3
  pressure : ScalarField 3
  potential : Position → ℝ

def speed (f : FlowData) (t : ℝ) (x : Position) : ℝ := ‖f.flow.velocity ⟨t⟩ x‖

def pressureEnergy (f : FlowData) (ρ t : ℝ) (x : Position) : ℝ :=
  f.pressure ⟨t⟩ x + ρ * (speed f t x)^2 / 2 + ρ * f.potential x

/-- A streamline at a fixed time, parameterized with velocity as tangent. -/
def IsStreamline (f : FlowData) (t : ℝ) (γ : ℝ → Position) : Prop :=
  ∀ s i, HasDerivAt (fun r => (γ r).val i) (f.flow.velocity ⟨t⟩ (γ s) i) s

def AlongStreamline (f : FlowData) (t : ℝ) (x y : Position) : Prop :=
  ∃ γ : ℝ → Position, IsStreamline f t γ ∧ ∃ a b, γ a = x ∧ γ b = y

def SteadyFlow (f : FlowData) (interval : Set ℝ) : Prop :=
  ∀ t ∈ interval, ∀ u ∈ interval, ∀ x,
    f.flow.rho ⟨t⟩ x = f.flow.rho ⟨u⟩ x ∧
    f.flow.velocity ⟨t⟩ x = f.flow.velocity ⟨u⟩ x ∧ f.pressure ⟨t⟩ x = f.pressure ⟨u⟩ x

def NoEnergyAdded (pumpWork loss : ℝ) : Prop := pumpWork = 0 ∧ loss = 0

/-- The ideal constant-density streamline law; density and enthalpy compatibility
are explicit. This is an assumed physical law, not a theorem of arbitrary fields. -/
def BernoulliPrinciple (f : FlowData) (ρ : ℝ) (interval : Set ℝ) : Prop :=
  0 < ρ ∧ SteadyFlow f interval ∧
  (∀ t ∈ interval, ∀ x, f.flow.rho ⟨t⟩ x = ρ ∧ f.flow.enthalpy ⟨t⟩ x = f.pressure ⟨t⟩ x / ρ) ∧
  ∀ t ∈ interval, ∀ x y, AlongStreamline f t x y →
    pressureEnergy f ρ t x = pressureEnergy f ρ t y

theorem pressureEnergy_eq_physlib (f : FlowData) (ρ t : ℝ) (x : Position)
    (hρ : ρ ≠ 0) (hh : f.flow.enthalpy ⟨t⟩ x = f.pressure ⟨t⟩ x / ρ) :
    pressureEnergy f ρ t x = ρ * bernoulliFunction 3 f.flow f.potential ⟨t⟩ x := by
  unfold pressureEnergy speed bernoulliFunction FluidFlow.specificKineticEnergy
  rw [hh, real_inner_self_eq_norm_sq]
  field_simp [hρ]
  ring

/-- Uniform section approximation: section speed is the norm of the fluid velocity. -/
structure PipeSection where
  point : Position
  area : ℝ

def ContinuityEquation (f : FlowData) (t : ℝ) (sections : Set PipeSection) : Prop :=
  ∀ a ∈ sections, ∀ b ∈ sections, 0 < a.area ∧ 0 < b.area ∧
    a.area * speed f t a.point = b.area * speed f t b.point

def ExtendedLossModel (f : FlowData) (ρ t : ℝ) (x y : Position)
    (pumpWork loss : ℝ) : Prop :=
  0 < ρ ∧ 0 ≤ loss ∧
    pressureEnergy f ρ t x + pumpWork = pressureEnergy f ρ t y + loss

def IncompressibleLowSpeed (f : FlowData) (ρ tolerance lowMachBound : ℝ)
    (soundSpeed : ScalarField 3) (domain : Set (ℝ × Position)) : Prop :=
  0 < ρ ∧ 0 ≤ tolerance ∧ tolerance < 1 ∧ 0 < lowMachBound ∧ lowMachBound < 0.3 ∧
  ∀ z ∈ domain, |f.flow.rho ⟨z.1⟩ z.2 - ρ| ≤ tolerance * ρ ∧
    0 < soundSpeed ⟨z.1⟩ z.2 ∧ speed f z.1 z.2 / soundSpeed ⟨z.1⟩ z.2 < lowMachBound

/-- Perfect-gas isentropic Pitot relation. It is a model assumption; neither
isentropy nor the ideal-gas equation is derived from the fluid fields here. -/
def CompressibilityModel (p ρ v c γ p₀ : ℝ) : Prop :=
  0 < p ∧ 0 < ρ ∧ 0 ≤ v ∧ 0 < c ∧ 1 < γ ∧ c^2 = γ * p / ρ ∧
    p₀ = p * Real.rpow (1 + (γ - 1) / 2 * (v / c)^2) (γ / (γ - 1))

def IdealAtHighSpeed (f : FlowData) (ρ t : ℝ) (x : Position)
    (c : ℝ) : Prop :=
  0 < ρ ∧ 0 < c ∧ speed f t x / c = 0.6 ∧ ∀ y, f.flow.rho ⟨t⟩ y = ρ

structure AirfoilData where
  lift : ℝ → ℝ
  attached : ℝ → Bool
  criticalAngle : ℝ
  /-- A parameterization of the surface, with oriented area-vector weight. -/
  surfacePoint : ℝ → Position
  areaVector : ℝ → EuclideanSpace ℝ (Fin 3)
  liftDirection : EuclideanSpace ℝ (Fin 3)

def BoundarySeparationModel (a : AirfoilData) (angles : Set ℝ) : Prop :=
  (∀ α ∈ angles, a.criticalAngle < α → a.attached α = false) ∧
  ∃ α ∈ angles, ∃ β ∈ angles,
    a.criticalAngle < α ∧ α < β ∧ a.lift β < a.lift α

def IdealAtHighAngle (a : AirfoilData) (angles : Set ℝ) : Prop :=
  (∃ α ∈ angles, a.criticalAngle < α) ∧ ∀ α ∈ angles, a.attached α = true

def LosslessDrainage (loss : ℝ → ℝ) (times : Set ℝ) : Prop :=
  ∀ t ∈ times, loss t = 0

def PressureDropsWithSpeed (f : FlowData) (ρ t : ℝ) (x y : Position) : Prop :=
  0 < ρ → f.potential x = f.potential y →
    pressureEnergy f ρ t x = pressureEnergy f ρ t y →
    speed f t x < speed f t y → f.pressure ⟨t⟩ y < f.pressure ⟨t⟩ x

theorem pressureDropsWithSpeed_proof (f : FlowData) (ρ t : ℝ) (x y : Position) :
    PressureDropsWithSpeed f ρ t x y := by
  intro hρ hpot henergy hv
  have hx : 0 ≤ speed f t x := norm_nonneg _
  have hy : 0 ≤ speed f t y := norm_nonneg _
  have hsq : (speed f t x)^2 < (speed f t y)^2 := by nlinarith
  unfold pressureEnergy at henergy
  rw [hpot] at henergy
  nlinarith [mul_pos hρ (sub_pos.mpr hsq)]

def SpeedUpInConstriction (A₁ A₂ v₁ v₂ : ℝ) : Prop :=
  0 < A₂ → A₂ < A₁ → 0 < v₁ → A₁ * v₁ = A₂ * v₂ → v₁ < v₂

theorem speedUpInConstriction_proof (A₁ A₂ v₁ v₂ : ℝ) :
    SpeedUpInConstriction A₁ A₂ v₁ v₂ := by
  intro hA hlt hv hq
  nlinarith [mul_pos (sub_pos.mpr hlt) hv]

def VenturiPrediction (f : FlowData) (ρ t : ℝ) (inlet throat : PipeSection) : Prop :=
  0 < ρ → 0 < throat.area → throat.area < inlet.area →
    0 < speed f t inlet.point →
    inlet.area * speed f t inlet.point = throat.area * speed f t throat.point →
    f.potential inlet.point = f.potential throat.point →
    pressureEnergy f ρ t inlet.point = pressureEnergy f ρ t throat.point →
    f.pressure ⟨t⟩ throat.point < f.pressure ⟨t⟩ inlet.point

theorem venturiPrediction_proof (f : FlowData) (ρ t : ℝ) (a b : PipeSection) :
    VenturiPrediction f ρ t a b := by
  intro hρ hA hlt hv hq hpot he
  exact pressureDropsWithSpeed_proof f ρ t a.point b.point hρ hpot he
    (speedUpInConstriction_proof _ _ _ _ hA hlt hv hq)

/-- Parameterized surface pressure traction, integrated over the surface chart.
The area vector includes the surface Jacobian; positive pressure acts inward. -/
def pressureLift (f : FlowData) (a : AirfoilData) (t : ℝ) : ℝ :=
  ∫ s in (0 : ℝ)..1, inner ℝ (-(f.pressure ⟨t⟩ (a.surfacePoint s)) • a.areaVector s)
    a.liftDirection

def LowSpeedLiftPrediction (f : FlowData) (a : AirfoilData)
    (t α c lowMachBound angleBound tolerance measuredLift : ℝ) : Prop :=
  0 < c ∧ 0 < lowMachBound ∧ lowMachBound < 0.3 ∧
  0 ≤ angleBound ∧ |α| ≤ angleBound ∧ 0 ≤ tolerance ∧
  (∀ s ∈ Set.Icc (0 : ℝ) 1, speed f t (a.surfacePoint s) / c < lowMachBound) ∧
  IntervalIntegrable (fun s => inner ℝ (-(f.pressure ⟨t⟩ (a.surfacePoint s)) •
    a.areaVector s) a.liftDirection) MeasureTheory.volume 0 1 ∧
  |measuredLift - pressureLift f a t| ≤ tolerance

def HighSpeedStagnationPrediction (ρ v c p p₀ : ℝ) : Prop :=
  0 < ρ ∧ 0 < c ∧ v / c = 0.6 ∧ p₀ - p = ρ * v^2 / 2

def HighSpeedDeviationObs (ρ v c p p₀ tolerance : ℝ) : Prop :=
  0 < ρ ∧ 0 < v ∧ 0 < c ∧ v / c = 0.6 ∧ 0 ≤ tolerance ∧ ρ * v^2 / 2 < p₀ - p ∧
    |((p₀ - p) / (ρ * v^2 / 2) - 1) - 0.09| ≤ tolerance

def StallPrediction (a : AirfoilData) (angles : Set ℝ) : Prop :=
  StrictMonoOn a.lift angles

def StallObs (a : AirfoilData) (angles : Set ℝ) : Prop :=
  ∃ α ∈ angles, ∃ β ∈ angles,
    a.criticalAngle < α ∧ α < β ∧ a.lift β < a.lift α

structure DrainageData where
  height : ℝ → ℝ
  exitSpeed : ℝ → ℝ
  reservoirArea : ℝ
  orificeArea : ℝ
  gravity : ℝ

def LosslessDrainPrediction (d : DrainageData) (times : Set ℝ) : Prop :=
  0 < d.gravity ∧ 0 < d.reservoirArea ∧ 0 < d.orificeArea ∧
  ∀ t ∈ times, 0 < d.height t ∧
    d.exitSpeed t = Real.sqrt (2 * d.gravity * d.height t) ∧
    HasDerivAt d.height (-(d.orificeArea / d.reservoirArea) * d.exitSpeed t) t

/-- Positive specific-energy loss fits measured outflow, whereas ideal Torricelli
does not. This encodes a data assertion, not a theorem about measurements. -/
def DrainDeviationObs (d : DrainageData) (loss : ℝ → ℝ)
    (times : Set ℝ) (deviationTolerance fitTolerance : ℝ) : Prop :=
  0 < d.gravity ∧ 0 < d.reservoirArea ∧ 0 < d.orificeArea ∧
  0 ≤ deviationTolerance ∧ 0 ≤ fitTolerance ∧ times.Nonempty ∧
  (∀ t ∈ times, 0 < d.height t ∧ 0 ≤ d.exitSpeed t ∧ 0 < loss t ∧
    |d.exitSpeed t - Real.sqrt (2 * (d.gravity * d.height t - loss t))| ≤ fitTolerance ∧
    loss t < d.gravity * d.height t ∧
    HasDerivAt d.height (-(d.orificeArea / d.reservoirArea) * d.exitSpeed t) t) ∧
  ∃ t ∈ times,
    deviationTolerance < |d.exitSpeed t - Real.sqrt (2 * d.gravity * d.height t)|

end Scilib.Formalization.Bernoulli
