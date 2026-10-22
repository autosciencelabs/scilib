# Atomic Structure: formal correspondence

All 13 existing theory statements, experimental records, and graph edges are
preserved. Their `formal` entries name representative mathematical statements
and related proofs, not certificates for the existing graph edges.

| Node | Mathematical reading | Important boundary |
| --- | --- | --- |
| `subatomicElectronTheory` | Every material in a specified nonempty class has positive particle emission rate, the same negative elementary charge, and positive mass smaller than that material's atomic mass. | Universality and emission rates are assumptions over the supplied material class; occurrence in nature is not proved. |
| `thomsonModel` | A neutral atom with uniform positive charge density inside a sphere and embedded negative electrons; the density integral is normalized to total positive charge. | A static charge model, not a scattering calculation or a proof of atomic stability. |
| `rutherfordModel` | Positive charge is supported inside a small nuclear ball; nearly all mass is there, with explicit size and missing-mass fractions and normalized nonnegative densities. | Does not derive a point-charge potential, trajectories, or scattering cross section. |
| `bohrModel` | Three-dimensional attractive PhysLib hydrogen, with stationary level energies, Bohr radii, and quantized angular momenta. | Defines a level scheme and algebraic orbital parameters, not eigenfunctions or dynamical orbits. PhysLib itself leaves identification of the energy levels with the Hamiltonian's point spectrum unproved. |
| `vacuumCathodeTube` | Positive low gas pressure, voltage above a supplied high-voltage threshold, positive electrode gap, and the uniform-field relation `E = V / gap`. | Ideal apparatus conditions; neither gas breakdown nor electron production is derived. |
| `alphaParticleBeam` | Two protons, two neutrons, no bound electrons, positive mass, charge `2e`, and energy above a supplied threshold. | Particle composition and beam energy are supplied data, not a derived nuclear model. |
| `mercuryVaporTube` | Identified mercury gas at low pressure, a sufficiently hot source, and nonnegative incident energies matching requested settings within tolerance. | Gas identity is input metadata; thermionic emission is represented by a temperature condition, not a derived emission law. |
| `hydrogenDischargeTube` | Identified hydrogen at low pressure under a positive accelerating field. | Does not derive electrical breakdown, excitation, or the measured spectrum. |
| `universalChargeToMassRatio` | All supplied materials have the same specific-charge magnitude, above a specified multiple of a reference ratio. | Equal charge and mass imply universality; the word "high" additionally needs the explicit magnitude bound. |
| `smallAngleScatteringOnly` | Every event in the supplied nonempty impact-parameter domain has nonnegative deflection below a bound strictly smaller than 90 degrees. | A representative bounded-deflection prediction, not a consequence proved from the Thomson density. |
| `largeAngleBackscattering` | A repulsive point-Coulomb deflection model with a heavy target and an available event between 90 and 180 degrees. | The Rutherford angle formula is assumed, not derived from Newton's equations. A sufficiently small available impact parameter gives a deflection above 90 degrees. Small-angle-only and backscattering predictions are proved incompatible for the same scattering data. |
| `discreteEnergyTransfer` | Energy losses are gaps between ordered levels; excitation voltages satisfy `e V = loss`; current has downward jumps at specified thresholds. | A separate excitation/transport model, appropriate for mercury. Hydrogen levels do not establish the mercury excitation energy or current drops. No numerical 4.9 eV value is asserted by this generic predicate. |
| `discreteSpectralLines` | A nonempty collection of positive hydrogen emission frequencies indexed by downward level transitions. | Countable transition indexing, not topological discreteness: spectral lines have series limits. It does not assert every possible transition is experimentally allowed or measured; selection rules and intensities require additional physics. |

## Main proved connections

- Common electron charge and mass give material-independent specific charge;
  the additional reference bound establishes the claimed high ratio.
- PhysLib's energy ordering gives ordered Bohr levels and positive emission
  frequencies. Photon energy is the difference between the two level energies.
- The local Bohr energy assignment yields the transition-frequency family.
- The hydrogen Balmer formula is specialized to three dimensions. PhysLib uses
  zero-based indices: its lower index `1` is the usual principal quantum number `2`.
- For fixed lower level, different ordered upper indices give different frequencies.
- The modeled emission-frequency family and any selected spectral-line subset are countable.
- A small-angle-only model cannot also have an event above 90 degrees in the
  same impact-parameter domain.

The existing Bohr-to-mercury-current-drop edge and density-to-scattering edges
need additional assumptions and dynamics. They remain unmodified and uncertified.
