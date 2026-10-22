module

public import Physlib.CondensedMatter.Crystal.Basic
public import Physlib.Electromagnetism.Vacuum.HarmonicWave
public import Mathlib.Analysis.SpecialFunctions.Complex.Circle
public import Mathlib.Geometry.Euclidean.Angle.Unoriented.Basic
public import Mathlib.LinearAlgebra.Basis.Defs
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith

/-!
# Formal readings of the Bragg example

PhysLib supplies periodic crystal sites and harmonic electromagnetic potentials.
The embedding of sites, scattering-plane geometry, and equal-amplitude kinematic
interference model are local additions. We do not derive atomic scattering from
Maxwell's equations, nor peak widths or amorphous halos from atomic disorder.

All lengths use the same unit; angles are in radians and are glancing angles
measured from a reflecting plane. Positive integer diffraction orders exclude
the forward-scattering order. The standard path difference `2 d sin θ` is a
geometric model input here, not a proved optical ray-tracing result.

The eight predicates below express explicit mathematical readings. Experimental
purity, wavelength comparability, peak widths, and halo widths are parameters,
not inferred measurements. See `Scilib/Formalization/Bragg.md` for the node-by-node
correspondence and its limitations. Existing evidence-graph edges are not certified.
-/

@[expose] public noncomputable section
namespace Scilib.Formalization.Bragg

open scoped BigOperators
open Real

abbrev Vector := EuclideanSpace ℝ (Fin 3)
abbrev Cells := Fin 3 → ℤ

/-- Spatial embedding and scattering factors added to PhysLib's combinatorial crystal. -/
structure CrystalData where
  crystal : Physlib.CondensedMatter.Crystal Cells
  latticeBasis : Module.Basis (Fin 3) ℝ Vector
  offset : crystal.UnitCell → Vector
  scatteringFactor : crystal.UnitCell → ℂ

def sitePosition (c : CrystalData) (s : c.crystal.Site) : Vector :=
  (∑ i : Fin 3, (s.cell i : ℝ) • c.latticeBasis i) + c.offset s.label

/-- A periodic crystal whose sites lie on a selected family of equally spaced
planes; nonzero scattering factors represent scattering capability, not its derivation. -/
def CrystalLattice (c : CrystalData) (normal : Vector) (spacing : ℝ) : Prop :=
  ‖normal‖ = 1 ∧ 0 < spacing ∧
  (∀ s : c.crystal.Site, ∃ n : ℤ,
    inner ℝ normal (sitePosition c s) = (n : ℝ) * spacing) ∧
  ∃ label, c.scatteringFactor label ≠ 0

theorem sitePosition_translate (c : CrystalData) (a : Cells) (s : c.crystal.Site) :
    sitePosition c (a +ᵥ s) =
      (∑ i : Fin 3, (a i : ℝ) • c.latticeBasis i) + sitePosition c s := by
  simp [sitePosition, add_smul, Finset.sum_add_distrib, add_assoc]

def pathDifference (spacing θ : ℝ) : ℝ := 2 * spacing * sin θ

def phaseDifference (spacing wavelength θ : ℝ) : ℝ :=
  2 * π * pathDifference spacing θ / wavelength

def BraggCondition (spacing wavelength θ : ℝ) (order : ℤ) : Prop :=
  0 < spacing ∧ 0 < wavelength ∧ 0 < order ∧
    0 < θ ∧ θ ≤ π / 2 ∧ (order : ℝ) * wavelength = pathDifference spacing θ

/-- Adjacent equal-amplitude plane contributions have identical phase. -/
def ConstructiveInterference (spacing wavelength θ : ℝ) : Prop :=
  Circle.exp (phaseDifference spacing wavelength θ) = 1

theorem constructive_of_bragg (d wavelength θ : ℝ) (n : ℤ)
    (h : BraggCondition d wavelength θ n) :
    ConstructiveInterference d wavelength θ := by
  rcases h with ⟨hd, hWave, hn, hθ, hθmax, he⟩
  unfold ConstructiveInterference phaseDifference
  rw [← he]
  have hp : 2 * π * ((n : ℝ) * wavelength) / wavelength = (n : ℝ) * (2 * π) := by
    field_simp [ne_of_gt hWave]
  rw [hp]
  exact Circle.exp_int_mul_two_pi n

/-- Constructive interference in the chosen path-difference model, with no
claim that every real crystal has a nonzero reflection at every allowed order. -/
def BraggsLaw (spacing wavelength : ℝ) : Prop :=
  0 < spacing ∧ 0 < wavelength ∧
  ∀ θ n, BraggCondition spacing wavelength θ n →
    ConstructiveInterference spacing wavelength θ

theorem braggsLaw_proof (d wavelength : ℝ) (hd : 0 < d) (hWave : 0 < wavelength) :
    BraggsLaw d wavelength :=
  ⟨hd, hWave, fun θ n h => constructive_of_bragg d wavelength θ n h⟩

/-- Unit-amplitude single-scattering contributions from a finite stack of planes. -/
def stackAmplitude (planes : ℕ) (phase : ℝ) : ℂ :=
  ∑ j ∈ Finset.range planes, (Circle.exp ((j : ℝ) * phase) : ℂ)

def stackIntensity (planes : ℕ) (phase : ℝ) : ℝ := ‖stackAmplitude planes phase‖ ^ 2

theorem stackAmplitude_at_integer_phase (planes : ℕ) (n : ℤ) :
    stackAmplitude planes ((n : ℝ) * (2 * π)) = (planes : ℂ) := by
  simp [stackAmplitude]

theorem stackIntensity_at_bragg (planes : ℕ) (d wavelength θ : ℝ) (n : ℤ)
    (h : BraggCondition d wavelength θ n) :
    stackIntensity planes (phaseDifference d wavelength θ) = (planes : ℝ)^2 := by
  have hc := constructive_of_bragg d wavelength θ n h
  obtain ⟨m, hm⟩ := Circle.exp_eq_one.mp hc
  simp [stackIntensity, hm, stackAmplitude_at_integer_phase]

theorem stackIntensity_le (planes : ℕ) (phase : ℝ) :
    stackIntensity planes phase ≤ (planes : ℝ)^2 := by
  have hn : ‖stackAmplitude planes phase‖ ≤ (planes : ℝ) := by
    unfold stackAmplitude
    calc
      ‖∑ j ∈ Finset.range planes, (Circle.exp ((j : ℝ) * phase) : ℂ)‖ ≤
          ∑ j ∈ Finset.range planes, ‖(Circle.exp ((j : ℝ) * phase) : ℂ)‖ := norm_sum_le _ _
      _ = (planes : ℝ) := by simp
  unfold stackIntensity
  nlinarith [norm_nonneg (stackAmplitude planes phase)]

/-- In the equal-amplitude finite-stack model, a Bragg angle attains the
global upper bound. This proves reinforcement, not a quantitative peak width. -/
theorem bragg_is_global_max (planes : ℕ) (d wavelength θ : ℝ) (n : ℤ)
    (h : BraggCondition d wavelength θ n) (otherPhase : ℝ) :
    stackIntensity planes otherPhase ≤ stackIntensity planes (phaseDifference d wavelength θ) := by
  rw [stackIntensity_at_bragg planes d wavelength θ n h]
  exact stackIntensity_le planes otherPhase

structure BeamData where
  vacuum : Electromagnetism.FreeSpace
  wavelength : ℝ
  amplitude : Fin 2 → ℝ
  phase : Fin 2 → ℝ
  potential : Electromagnetism.ElectromagneticPotential 3

def waveNumber (b : BeamData) : ℝ := 2 * π / b.wavelength

/-- Exact monochromatic, parallel plane-wave idealization in coordinates whose
x-axis is the beam direction. The nonzero amplitude excludes the zero field. -/
def MonochromaticXRayBeam (b : BeamData) : Prop :=
  0 < b.wavelength ∧ (∃ i, b.amplitude i ≠ 0) ∧
  b.potential = Electromagnetism.ElectromagneticPotential.harmonicWaveX
    b.vacuum (waveNumber b) b.amplitude b.phase

/-- A representative harmonic electromagnetic X-ray model. Comparability to
atomic plane spacing is specified by supplied positive ratio bounds. -/
def WaveNatureOfXRays (b : BeamData) (spacing minRatio maxRatio : ℝ) : Prop :=
  MonochromaticXRayBeam b ∧ 0 < spacing ∧ 0 < minRatio ∧ minRatio ≤ maxRatio ∧
    minRatio * spacing ≤ b.wavelength ∧ b.wavelength ≤ maxRatio * spacing

theorem monochromatic_satisfies_maxwell (b : BeamData) (h : MonochromaticXRayBeam b) :
    Electromagnetism.ElectromagneticPotential.IsExtrema b.vacuum b.potential 0 := by
  rw [h.2.2]
  apply Electromagnetism.ElectromagneticPotential.harmonicWaveX_isExtrema
  exact ne_of_gt (div_pos (mul_pos (by norm_num) Real.pi_pos) h.1)

/-- No nonzero exact translation preserves the infinite idealized atomic pattern.
This is a nonperiodicity surrogate, not a probability distribution for disorder.
A finite crystal fragment also lacks global translation symmetry, so this
predicate must not be used to classify arbitrary finite specimens. -/
def RandomAmorphousStructure (atoms : Set Vector) : Prop :=
  atoms.Nonempty ∧ ¬ ∃ a : Vector, a ≠ 0 ∧ ∀ x, x ∈ atoms ↔ x + a ∈ atoms

/-- Purity and calibrated angular mounting of one lattice orientation. The
rotation maps the chosen normal to the prescribed glancing angle with the beam. -/
def SingleCrystalTarget (c : CrystalData) (normal beamDirection : Vector)
    (spacing impurityFraction purityTolerance : ℝ)
    (rotation : ℝ → Vector ≃ₗᵢ[ℝ] Vector) (scan : Set ℝ) : Prop :=
  CrystalLattice c normal spacing ∧ ‖beamDirection‖ = 1 ∧ scan.Nonempty ∧
  0 ≤ impurityFraction ∧ impurityFraction ≤ purityTolerance ∧ purityTolerance < 1 ∧
  ∀ θ ∈ scan, 0 ≤ θ ∧ θ ≤ π / 2 ∧
    InnerProductGeometry.angle (rotation θ normal) beamDirection = π / 2 - θ

/-- A nonempty set of major peaks, satisfying Bragg's law, with supplied small
half-width bounds and half-height shoulders. This is a profile prediction,
not a consequence proved from the periodic sites alone. -/
def BraggPeakPrediction (spacing wavelength : ℝ) (intensity : ℝ → ℝ)
    (peaks : Set ℝ) (halfWidth maxHalfWidth : ℝ) : Prop :=
  0 < spacing ∧ 0 < wavelength ∧ peaks.Nonempty ∧
  0 < halfWidth ∧ halfWidth ≤ maxHalfWidth ∧ maxHalfWidth < π / 4 ∧
  (∀ θ, 0 ≤ intensity θ) ∧
  ∀ θ ∈ peaks, (∃ n : ℤ, BraggCondition spacing wavelength θ n) ∧
    halfWidth < θ ∧ θ + halfWidth < π / 2 ∧ 0 < intensity θ ∧
    (∀ φ, |φ - θ| ≤ halfWidth → intensity φ ≤ intensity θ) ∧
    intensity (θ - halfWidth) ≤ intensity θ / 2 ∧
    intensity (θ + halfWidth) ≤ intensity θ / 2

/-- A continuous broad radial halo: a half-height core of specified minimum
width and lower shoulders. This describes a profile; disorder alone is not
proved to produce it. Width units are those of the radial scattering coordinate. -/
def AmorphousDiffuseScattering (intensity : ℝ → ℝ)
    (center radius minWidth : ℝ) : Prop :=
  Continuous intensity ∧ (∀ q, 0 ≤ intensity q) ∧
  0 < radius ∧ 0 < minWidth ∧ minWidth ≤ 2 * radius ∧ 2 * radius < center ∧
  0 < intensity center ∧
  (∀ q, |q - center| ≤ radius →
    intensity center / 2 ≤ intensity q ∧ intensity q ≤ intensity center) ∧
  intensity (center - 2 * radius) ≤ intensity center / 2 ∧
  intensity (center + 2 * radius) ≤ intensity center / 2

end Scilib.Formalization.Bragg
