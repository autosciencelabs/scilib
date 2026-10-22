# Blackbody Radiation: formal correspondence

The eight original theory statements, experiments, and graph edges are preserved.
The new references link them to explicit local mathematical models and proofs.
These links are not certificates of the entire evidence graph.

## Quantities and conventions

PhysLib's `BlackBody.spectralRadiance` is radiance per frequency, not energy
density. The local isotropic-vacuum-cavity model uses `u_ν = 4π B_ν / c`.
Wavelength spectra have the additional Jacobian `c / λ²`; replacing frequency
by `c / λ` without this factor would be wrong. Quantities must use units
consistent with PhysLib's Planck and Boltzmann constants. Frequency and
wavelength are positive in physical statements.

| Existing node | Formal reading | Boundary |
| --- | --- | --- |
| `classicalElectrodynamics` | A cavity family of standing electromagnetic modes satisfying PhysLib's vacuum Maxwell/variational predicate and conducting-wall electric conditions, with classical mean energy `k_B T`, continuum mode density `8πν²/c³`, and the spectral-energy closure. | Equipartition, mode counting, and the link from statistical mode energy to spectrum are explicit assumptions, not derived from Maxwell alone. |
| `rayleighJeansLaw` | Positive temperature and the frequency energy density `8π k_B T ν²/c³`. | A continuum idealization; its polynomial extension outside nonnegative frequencies has no physical meaning. Its cutoff energy is proved to grow cubically and diverge. |
| `wiensDistributionLaw` | Wien's exponential radiance formula, agreement with supplied short-wavelength data, and a mismatch with supplied infrared data beyond their stated tolerance; an explicit positive frequency split separates the two data sets. | Measurements and band boundaries are supplied; historical agreement/failure is not proved. This is Wien's distribution, not Wien's displacement law. |
| `planckQuantumHypothesis` | Oscillator levels `n hν`, Planck's thermal mean oscillator energy, and the mode-to-radiance relation. | Quantization alone is insufficient: the thermal occupation formula is an additional statistical assumption. Under this package the resulting radiance is proved equal to PhysLib's Planck formula. |
| `thermodynamicEquilibrium` | Common wall/radiation temperature, zero net energy and matter flux through the wall, and stationary stored energy. | Representative equilibrium conditions, not a full statistical ensemble or entropy-maximization theory. |
| `finiteTotalEnergyObservation` | A nonnegative spectrum locally integrable on every finite frequency interval, whose integrated energy is uniformly bounded by a measured finite total plus tolerance. | A supplied empirical bound; not an invented measured value. Integrability is required to avoid Lean's default value for an undefined integral. |
| `ultravioletDivergence` | Wavelength energy density tends to infinity as wavelength tends to zero from above **and** integrated frequency energy tends to infinity with the cutoff. | The integrated clause is stronger than the informal pointwise statement and is required for the contradiction with finite total energy. Both clauses are proved for the Rayleigh–Jeans model. |
| `universalBlackbodySpectrum` | One continuous positive-frequency spectrum equals PhysLib's Planck formula throughout the positive-frequency domain and fits supplied measurements within tolerance. | Formula coverage is universal; empirical agreement is limited to the supplied data and is not inferred from the formula. |

## What is proved

- Isotropic Planck energy density is positive and obeys the wavelength/frequency
  change-of-variables relation inherited from PhysLib.
- The specified classical cavity model gives the Rayleigh–Jeans density.
- Its frequency-cutoff energy is `A R³ / 3`, for positive coefficient `A`.
- Its short-wavelength density and integrated energy both diverge.
- That integrated divergence is incompatible with the finite-total-energy
  observation predicate for the **same frequency spectrum**.
- Wien radiance is positive at positive frequency.
- Adjacent oscillator levels differ by `hν`; the quantum/statistical cavity
  assumptions give exactly PhysLib's Planck radiance.
- Planck radiance is continuous on positive frequencies at positive temperature.
  The statistical model plus an explicit fit to measured data establishes the
  combined universal-spectrum predicate; the empirical fit remains a hypothesis.

We do not derive the Stefan–Boltzmann total-energy integral, recover the
Rayleigh–Jeans or Wien asymptotic limits of Planck's formula, or verify historical
measurements. In particular, the graph's quantum-to-empirical-fit edge still
requires experimental data and interpretation assumptions.
