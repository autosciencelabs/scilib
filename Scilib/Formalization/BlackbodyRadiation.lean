module

public import Physlib.QuantumMechanics.Blackbody.PlancksLaw
public import Physlib.Electromagnetism.Vacuum.HarmonicWave
public import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
public import Mathlib.Topology.Algebra.Order.Field
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# Formal readings of the blackbody-radiation example

PhysLib supplies Planck radiance, its positivity, and the wavelength/frequency
correspondence. Local classical and quantum cavity models make statistical
assumptions explicit. Neither equipartition, cavity mode counting, nor the Planck
thermal mean energy is derived from Maxwell or quantum dynamics here.

Radiance and energy density are different: in an isotropic vacuum cavity the
conversion is `u_ν = (4π/c) B_ν`. Wavelength densities include their Jacobian.
The ultraviolet model below has BOTH pointwise wavelength divergence and an
unbounded integrated frequency energy. Pointwise divergence alone would not
contradict a finite integrated energy observation.

Measured fit and mismatch predicates describe supplied data and tolerances;
they do not establish historical observations. The graph is unchanged and not
certified. See `BlackbodyRadiation.md` for correspondence and limitations.
-/

@[expose] public noncomputable section
namespace Scilib.Formalization.BlackbodyRadiation

open Real Constants Filter MeasureTheory
open scoped Topology

def energyDensity (B : BlackBody) (c : SpeedOfLight) (ν : ℝ) : ℝ :=
  (4 * π / (c : ℝ)) * B.spectralRadiance c ν

def wavelengthEnergyDensity (B : BlackBody) (c : SpeedOfLight) (lam : ℝ) : ℝ :=
  (4 * π / (c : ℝ)) * B.spectralRadianceWave c lam

theorem planck_energyDensity_pos (B : BlackBody) (c : SpeedOfLight) (ν : ℝ)
    (hT : 0 < (B.T : ℝ)) (hν : 0 < ν) : 0 < energyDensity B c ν :=
  mul_pos (div_pos (mul_pos (by norm_num) pi_pos) c.val_pos)
    (B.spectralRadiance_pos c ν hν hT)

theorem planck_density_change_of_variables (B : BlackBody) (c : SpeedOfLight) (lam : ℝ)
    (hT : 0 < (B.T : ℝ)) (hlam : 0 < lam) :
    wavelengthEnergyDensity B c lam =
      ((c : ℝ) / lam^2) * energyDensity B c ((c : ℝ) / lam) := by
  unfold wavelengthEnergyDensity energyDensity
  rw [B.spectralRadianceWave_eq_spectralRadiance c lam hlam hT]
  ring

def rayleighJeansCoefficient (B : BlackBody) (c : SpeedOfLight) : ℝ :=
  8 * π * (kB : ℝ) * (B.T : ℝ) / (c : ℝ)^3

/-- Polynomial extension to the real line; only nonnegative frequencies are physical. -/
def rayleighJeansDensity (B : BlackBody) (c : SpeedOfLight) (ν : ℝ) : ℝ :=
  rayleighJeansCoefficient B c * ν^2

def rayleighJeansWavelengthDensity (B : BlackBody) (lam : ℝ) : ℝ :=
  (8 * π * (kB : ℝ) * (B.T : ℝ)) * (lam⁻¹)^4

def cutoffEnergy (density : ℝ → ℝ) (cutoff : ℝ) : ℝ := ∫ ν in (0 : ℝ)..cutoff, density ν

def RayleighJeansLaw (B : BlackBody) (c : SpeedOfLight) (density : ℝ → ℝ) : Prop :=
  0 < (B.T : ℝ) ∧ density = rayleighJeansDensity B c

theorem rayleighJeansCoefficient_pos (B : BlackBody) (c : SpeedOfLight)
    (hT : 0 < (B.T : ℝ)) : 0 < rayleighJeansCoefficient B c := by
  unfold rayleighJeansCoefficient
  exact div_pos (mul_pos (mul_pos (mul_pos (by norm_num) pi_pos) kB_pos) hT)
    (pow_pos c.val_pos 3)

theorem rayleighJeans_cutoff (B : BlackBody) (c : SpeedOfLight) (R : ℝ) :
    cutoffEnergy (rayleighJeansDensity B c) R = rayleighJeansCoefficient B c * R^3 / 3 := by
  unfold cutoffEnergy rayleighJeansDensity
  rw [intervalIntegral.integral_const_mul, integral_pow]
  norm_num
  ring

theorem rayleighJeans_change_of_variables (B : BlackBody) (c : SpeedOfLight)
    (lam : ℝ) (hlam : lam ≠ 0) :
    rayleighJeansWavelengthDensity B lam =
      ((c : ℝ) / lam^2) * rayleighJeansDensity B c ((c : ℝ) / lam) := by
  unfold rayleighJeansWavelengthDensity rayleighJeansDensity rayleighJeansCoefficient
  field_simp

def UltravioletDivergence (frequencyDensity wavelengthDensity : ℝ → ℝ) : Prop :=
  Tendsto wavelengthDensity (nhdsWithin 0 (Set.Ioi 0)) atTop ∧
  Tendsto (cutoffEnergy frequencyDensity) atTop atTop

theorem rayleighJeans_ultraviolet (B : BlackBody) (c : SpeedOfLight)
    (hT : 0 < (B.T : ℝ)) :
    UltravioletDivergence (rayleighJeansDensity B c) (rayleighJeansWavelengthDensity B) := by
  constructor
  · exact Filter.Tendsto.const_mul_atTop
      (mul_pos (mul_pos (mul_pos (by norm_num) pi_pos) kB_pos) hT)
      ((tendsto_pow_atTop (n := 4) (by decide)).comp tendsto_inv_nhdsGT_zero)
  · have heq : cutoffEnergy (rayleighJeansDensity B c) =
        fun R => (rayleighJeansCoefficient B c / 3) * R^3 := by
      funext R
      rw [rayleighJeans_cutoff]
      ring
    rw [heq]
    exact Filter.Tendsto.const_mul_atTop
      (div_pos (rayleighJeansCoefficient_pos B c hT) (by norm_num))
      (tendsto_pow_atTop (n := 3) (by decide))

theorem rayleighJeansLaw_diverges (B : BlackBody) (c : SpeedOfLight) (density : ℝ → ℝ)
    (h : RayleighJeansLaw B c density) :
    UltravioletDivergence density (rayleighJeansWavelengthDensity B) := by
  rw [h.2]
  exact rayleighJeans_ultraviolet B c h.1

/-- Finite measured total energy bounds every truncated integral. Local
integrability rules out interpreting Lean's default undefined integral as zero. -/
def FiniteTotalEnergyObservation (density : ℝ → ℝ) (measuredTotal tolerance : ℝ) : Prop :=
  0 ≤ measuredTotal ∧ 0 ≤ tolerance ∧ (∀ ν, 0 ≤ ν → 0 ≤ density ν) ∧
  ∀ R, 0 ≤ R → IntervalIntegrable density volume 0 R ∧
    0 ≤ cutoffEnergy density R ∧ cutoffEnergy density R ≤ measuredTotal + tolerance

theorem ultraviolet_finite_incompatible (density wavelengthDensity : ℝ → ℝ)
    (total tolerance : ℝ) (hd : UltravioletDivergence density wavelengthDensity)
    (hf : FiniteTotalEnergyObservation density total tolerance) : False := by
  have hlarge := hd.2.eventually (eventually_gt_atTop (total + tolerance))
  obtain ⟨R, hR, hbig⟩ := ((eventually_ge_atTop (0 : ℝ)).and hlarge).exists
  have hbound := (hf.2.2.2 R hR).2.2
  exact (not_lt_of_ge hbound) hbig

structure ClassicalCavity where
  vacuum : Electromagnetism.FreeSpace
  modes : ℕ → Electromagnetism.ElectromagneticPotential 3
  angularFrequency : ℕ → ℝ
  electricProfile : ℕ → Space 3 → EuclideanSpace ℝ (Fin 3)
  boundary : Set (Space 3)
  normal : Space 3 → EuclideanSpace ℝ (Fin 3)
  meanModeEnergy : ℕ → ℝ
  densityOfModes : ℝ → ℝ
  spectrum : ℝ → ℝ

/-- Maxwell standing modes with conducting-wall electric conditions, classical
equipartition, and the continuum cavity mode-density approximation. Mode
counting and equipartition are assumptions, not consequences of Maxwell alone. -/
def ClassicalElectrodynamics (B : BlackBody) (c : ClassicalCavity) : Prop :=
  0 < (B.T : ℝ) ∧ c.boundary.Nonempty ∧
  (∀ n, 0 < c.angularFrequency n ∧
    (∃ x, c.electricProfile n x ≠ 0) ∧
    Electromagnetism.ElectromagneticPotential.IsExtrema c.vacuum (c.modes n) 0 ∧
    c.meanModeEnergy n = (kB : ℝ) * (B.T : ℝ) ∧
    (∀ t x, (c.modes n).electricField c.vacuum.c t x =
      cos (c.angularFrequency n * t.val) • c.electricProfile n x) ∧
    ∀ t x, x ∈ c.boundary → ‖c.normal x‖ = 1 ∧
      ∀ v, inner ℝ (c.normal x) v = 0 →
        inner ℝ ((c.modes n).electricField c.vacuum.c t x) v = 0) ∧
  (∀ ν, c.densityOfModes ν = 8 * π * ν^2 / (c.vacuum.c : ℝ)^3) ∧
  ∀ ν, c.spectrum ν = c.densityOfModes ν * ((kB : ℝ) * (B.T : ℝ))

theorem classical_to_rayleighJeans (B : BlackBody) (c : ClassicalCavity)
    (h : ClassicalElectrodynamics B c) : RayleighJeansLaw B c.vacuum.c c.spectrum := by
  refine ⟨h.1, ?_⟩
  funext ν
  rw [h.2.2.2.2 ν, h.2.2.2.1 ν]
  unfold rayleighJeansDensity rayleighJeansCoefficient
  ring

structure SpectralData where
  frequencies : Set ℝ
  measuredRadiance : ℝ → ℝ
  tolerance : ℝ → ℝ

def FitsOn (spectrum : ℝ → ℝ) (data : SpectralData) : Prop :=
  data.frequencies.Nonempty ∧ ∀ ν ∈ data.frequencies,
    0 < ν ∧ 0 ≤ data.measuredRadiance ν ∧ 0 ≤ data.tolerance ν ∧
    |spectrum ν - data.measuredRadiance ν| ≤ data.tolerance ν

def wienRadiance (B : BlackBody) (c : SpeedOfLight) (ν : ℝ) : ℝ :=
  (2 * (h : ℝ) * ν^3 / (c : ℝ)^2) * exp (-(h : ℝ) * ν / ((kB : ℝ) * (B.T : ℝ)))

def WiensDistributionLaw (B : BlackBody) (c : SpeedOfLight) (spectrum : ℝ → ℝ)
    (shortWavelengthData infraredData : SpectralData) (splitFrequency : ℝ) : Prop :=
  0 < (B.T : ℝ) ∧ spectrum = wienRadiance B c ∧ FitsOn spectrum shortWavelengthData ∧
  0 < splitFrequency ∧
  (∀ ν ∈ shortWavelengthData.frequencies, splitFrequency ≤ ν) ∧
  (∀ ν ∈ infraredData.frequencies, ν < splitFrequency) ∧
  infraredData.frequencies.Nonempty ∧ ∃ ν ∈ infraredData.frequencies,
    0 < ν ∧ 0 ≤ infraredData.measuredRadiance ν ∧ 0 ≤ infraredData.tolerance ν ∧
    infraredData.tolerance ν < |spectrum ν - infraredData.measuredRadiance ν|

theorem wienRadiance_pos (B : BlackBody) (c : SpeedOfLight) (ν : ℝ)
    (_hT : 0 < (B.T : ℝ)) (hν : 0 < ν) :
    0 < wienRadiance B c ν := by
  unfold wienRadiance
  exact mul_pos (div_pos (mul_pos (mul_pos (by norm_num) h_pos) (pow_pos hν 3))
    (pow_pos c.val_pos 2)) (exp_pos _)

/-- Quantized levels plus the thermal mean oscillator energy and the
mode-density-to-radiance relation. Thermal occupation is an explicit statistical
assumption: quantization alone does not imply the Planck distribution. -/
def PlanckQuantumHypothesis (B : BlackBody) (c : SpeedOfLight)
    (levels : ℕ → ℝ → ℝ) (meanEnergy spectrum : ℝ → ℝ) : Prop :=
  0 < (B.T : ℝ) ∧
  (∀ n ν, 0 < ν → levels n ν = (n : ℝ) * (h : ℝ) * ν) ∧
  (∀ ν, 0 < ν → meanEnergy ν = (h : ℝ) * ν /
    (exp ((h : ℝ) * ν / ((kB : ℝ) * (B.T : ℝ))) - 1)) ∧
  ∀ ν, 0 < ν → spectrum ν = (2 * ν^2 / (c : ℝ)^2) * meanEnergy ν

theorem quantum_step (B : BlackBody) (c : SpeedOfLight) (levels : ℕ → ℝ → ℝ)
    (meanEnergy spectrum : ℝ → ℝ) (hq : PlanckQuantumHypothesis B c levels meanEnergy spectrum)
    (n : ℕ) (ν : ℝ) (hν : 0 < ν) : levels (n + 1) ν - levels n ν = (h : ℝ) * ν := by
  rw [hq.2.1 (n + 1) ν hν, hq.2.1 n ν hν]
  push_cast
  ring

theorem quantum_planck_formula (B : BlackBody) (c : SpeedOfLight)
    (levels : ℕ → ℝ → ℝ) (meanEnergy spectrum : ℝ → ℝ)
    (hq : PlanckQuantumHypothesis B c levels meanEnergy spectrum) (ν : ℝ) (hν : 0 < ν) :
    spectrum ν = B.spectralRadiance c ν := by
  rw [hq.2.2.2 ν hν, hq.2.2.1 ν hν]
  unfold BlackBody.spectralRadiance
  rw [ite_eq_left hν]
  field_simp

structure EquilibriumData where
  wall : Set (Space 3)
  wallTemperature : Space 3 → ℝ
  radiationTemperature : ℝ
  netEnergyFlux : Space 3 → ℝ
  netParticleFlux : Space 3 → ℝ
  storedEnergy : ℝ → ℝ

/-- Representative equilibrium conditions: common temperature, no net exchange,
and stationary stored energy. This does not construct a full equilibrium ensemble. -/
def ThermodynamicEquilibrium (B : BlackBody) (e : EquilibriumData) : Prop :=
  e.wall.Nonempty ∧ e.radiationTemperature = (B.T : ℝ) ∧
  (∀ x ∈ e.wall, e.wallTemperature x = (B.T : ℝ) ∧
    e.netEnergyFlux x = 0 ∧ e.netParticleFlux x = 0) ∧
  ∀ t, e.storedEnergy t = e.storedEnergy 0

def UniversalBlackbodySpectrum (B : BlackBody) (c : SpeedOfLight) (spectrum : ℝ → ℝ)
    (data : SpectralData) : Prop :=
  0 < (B.T : ℝ) ∧ ContinuousOn spectrum (Set.Ioi 0) ∧
  (∀ ν, 0 < ν → spectrum ν = B.spectralRadiance c ν) ∧ FitsOn spectrum data

theorem planck_continuousOn (B : BlackBody) (c : SpeedOfLight) (hT : 0 < (B.T : ℝ)) :
    ContinuousOn (B.spectralRadiance c) (Set.Ioi 0) := by
  have hc : (c : ℝ) ≠ 0 := ne_of_gt c.val_pos
  have hf : ContinuousOn
      (fun ν : ℝ => 2 * (h : ℝ) * ν^3 / ((c : ℝ)^2 *
        (exp ((h : ℝ) * ν / ((kB : ℝ) * (B.T : ℝ))) - 1))) (Set.Ioi 0) := by
    intro ν hν
    have hx : 0 < (h : ℝ) * ν / ((kB : ℝ) * (B.T : ℝ)) :=
      div_pos (mul_pos h_pos hν) (mul_pos kB_pos hT)
    have he : 0 < exp ((h : ℝ) * ν / ((kB : ℝ) * (B.T : ℝ))) - 1 :=
      sub_pos.mpr (by simpa using Real.exp_strictMono hx)
    have hd : (c : ℝ)^2 * (exp ((h : ℝ) * ν / ((kB : ℝ) * (B.T : ℝ))) - 1) ≠ 0 :=
      mul_ne_zero (pow_ne_zero 2 hc) (ne_of_gt he)
    apply ContinuousAt.continuousWithinAt
    fun_prop
  apply hf.congr
  intro ν hν
  change 0 < ν at hν
  simp only [BlackBody.spectralRadiance, ite_eq_left hν]

/-- Statistical model plus an explicit empirical fit gives the combined node;
agreement with measurements is not inferred from quantization alone. -/
theorem quantum_to_universal_with_fit (B : BlackBody) (c : SpeedOfLight)
    (levels : ℕ → ℝ → ℝ) (meanEnergy spectrum : ℝ → ℝ) (data : SpectralData)
    (hq : PlanckQuantumHypothesis B c levels meanEnergy spectrum) (hfit : FitsOn spectrum data) :
    UniversalBlackbodySpectrum B c spectrum data := by
  have heq := quantum_planck_formula B c levels meanEnergy spectrum hq
  refine ⟨hq.1, ?_, heq, hfit⟩
  apply (planck_continuousOn B c hq.1).congr
  intro ν hν
  exact heq ν hν

theorem universal_spectrum_positive (B : BlackBody) (c : SpeedOfLight)
    (spectrum : ℝ → ℝ) (data : SpectralData) (hu : UniversalBlackbodySpectrum B c spectrum data)
    (ν : ℝ) (hν : 0 < ν) : 0 < spectrum ν := by
  rw [hu.2.2.1 ν hν]
  exact B.spectralRadiance_pos c ν hν hu.1

end Scilib.Formalization.BlackbodyRadiation
