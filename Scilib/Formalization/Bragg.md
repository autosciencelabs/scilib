# Bragg: correspondence between statements and formal declarations

The original statements, experiments, and evidence graph are preserved. Each
`formal` entry names a precise mathematical reading or a directly related proof.
The names alone do not certify the graph edges or establish experimental truth.

| Node | Formal reading | Coverage boundary |
| --- | --- | --- |
| `crystalLattice` | PhysLib's crystal sites embedded by a real basis and unit-cell offsets; sites lie on an equally spaced plane family and some scattering factor is nonzero. | Ideal infinite periodic lattice. Scattering factors are inputs; atomic scattering is not derived. Spatial translation of sites is proved. |
| `braggsLaw` | Positive spacing and wavelength; `n λ = 2 d sin θ` implies identical adjacent-plane phases for positive integer order and physical glancing angles. | The path-difference formula is assumed as geometry. Constructive phase alignment is proved; reflection strength and selection rules need more modeling. |
| `waveNatureOfXRays` | A nonzero harmonic electromagnetic potential using PhysLib's `harmonicWaveX`, with wavelength comparable to spacing under supplied ratio bounds. | Represents one ideal harmonic-wave family in vacuum, not every X-ray field. Its Maxwell property is proved using PhysLib. |
| `randomAmorphousStructure` | A nonempty ideal infinite atomic pattern with no nonzero exact translation symmetry. | A deterministic nonperiodicity surrogate: it does not define randomness or correlation decay. Finite crystal fragments also lack exact global periodicity and must not be classified by this criterion. |
| `monochromaticXRayBeam` | One positive wavelength and nonzero harmonic plane-wave amplitude in coordinates aligned with the beam. | Exact collimation/monochromaticity idealization; infinite plane waves do not represent finite beam apertures. |
| `singleCrystalTarget` | One lattice orientation, a bounded impurity fraction, and linear isometric rotations whose normal-to-beam angles match the glancing-angle scan. | Purity and mounting calibration are supplied conditions, not deductions or verified historical measurements. |
| `braggPeakPrediction` | Nonempty major peak locations obey Bragg's law, have positive intensity, local maximality, and half-height shoulders within supplied small widths. | Equal-amplitude finite-stack reinforcement and a global intensity bound are proved separately. Peak width and a full measured reflection profile are not derived. Minor side lobes are not asserted to satisfy Bragg's law. |
| `amorphousDiffuseScattering` | A continuous nonnegative radial intensity profile with a broad half-height core and lower shoulders. | Describes a representative halo. It does not prove that disorder causes this profile, exclude superimposed sharp peaks elsewhere, or provide an ensemble scattering calculation. |

## Proved interference model

For `N` equally weighted planes with phase step `δ`, the local model sums the
unit complex phasors `exp(i j δ)` for `j = 0, …, N-1`. Its intensity is the
squared modulus of that sum. At a Bragg angle all contributions align, so the
amplitude is `N` and intensity is `N²`. The triangle inequality bounds intensity
at every other phase by `N²`. This is a conditional kinematic scattering model;
it omits multiple scattering, absorption, atomic form factors, and systematic
absences. The electromagnetic potential and this scattering calculation are
not connected by a derived interaction law.

## Graph limitations

The current graph independently asserts that the lattice, wave nature, or
Bragg's law implies sharp peaks. None alone supplies wavelength, geometry,
illumination, nonvanishing structure factors, and resolution assumptions needed
for that full prediction. Those edges remain unmodified and uncertified.
