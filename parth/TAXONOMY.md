# Empirica: taxonomy of 10 reasoning situations, with 3 Earth-style episodes each

Status: DRAFT v3 (2026-10-18). Built from research and general knowledge, not from an official standard. No agreed taxonomy of "scientific phenomena" exists (see "How this was built").

**What is decided and what is not:**
- DECIDED (as the working plan, Parth 2026-10-17): the 10 **categories** (situations).
- SHORTLISTED (Parth 2026-10-18): **3 episodes per category** (30 in all), listed in suggested build order. Rules: famous episodes taught to a general scientific public; materials-informatics episodes in #1, #6, #9 and #10 (listed first there); the right answer must be documented.
- NOT DONE YET: the **source check**. Facts marked "(v)" come from memory and must be checked against the primary paper before they go into a Lean file. An episode that cannot be sourced is dropped, and its category keeps the other two.

## The idea in one line
Each entry is a **situation where evidence meets a claim and reasoning can go wrong in a specific way**. The verifier must catch that specific way. Each episode is a real "which model of the world is right?" problem with a known right answer, so a verifier's score on it can be checked.

## What an episode must look like (from `earth.png`)
The target form is the EarthIsFlat graph from Nilesh's `.sci` example:

| Layer | What it is | Earth example |
|---|---|---|
| Rival models | 3-4 competing theories, each `composed_of` shared claims | FlatEarthNearSun, SphericalEarth, OblateEarth |
| Claims | Reusable pieces, some shared between rivals | SunIsDistant, SurfaceIsPlane, SurfaceIsCurved |
| Claim relations | `contradicts`, `implies`, `reduces_to` (old theory as a limit), `forbids` | Plane contradicts Curved; Sphere reduces_to Plane |
| Observations | 5-6 independent experiments, each `predicts`-ed or forbidden by several rivals | Eratosthenes, LunarEclipseShadow, MeridianArcs |
| Hidden assumptions | Background claims observations `relies_on`, with a status (declared / suspected / discovered) | LightTravelsInStraightLines, UniformityOfNature |

**Earth-style test** (each episode should pass; weak ones are marked "Thin"):
1. At least 3 rival models built from shared claims (one claim used by 2+ rivals).
2. At least one `contradicts` pair, plus an `implies`, `forbids` or `reduces_to`.
3. At least 5 observations: some separate the rivals, and at least one is predicted by all of them.
4. At least 2 hidden assumptions reused by several observations.
5. A documented right answer, and a source for every observation.
6. The one thing that shows the category's check (dof 0 = calibration, an incomplete rival set, and so on).

## Index

| # | Category (the check) | A (informatics first where marked) | B | C |
|---|---|---|---|---|
| 1 | Fit vs test | [informatics] DFT functionals PBE / B3LYP / PBE0 | Bohr's atom | Mendeleev's periodic law |
| 2 | Crucial test between rivals | Nature of light (Foucault 1850) | Meselson-Stahl (1958) | Lavoisier vs phlogiston |
| 3 | Blame among auxiliaries | Uranus (1846) and Mercury (1859) | Solar neutrino problem | OPERA neutrinos (Thin) |
| 4 | Hidden assumption in the measurement | Continental drift to plate tectonics | Baade's Cepheid populations | Mesosomes (Thin) |
| 5 | Conflicting results and replication | LK-99 (2023) | Cold fusion (1989) | Arsenic life GFAJ-1 |
| 6 | Search and selection effects | [informatics] GNoME (partly contested) | 750 GeV excess | Higgs 2012 (the contrast) |
| 7 | Exploratory discovery (record vs reading) | Quasicrystals (1982) | Penzias-Wilson (1964-65) | Rayleigh-Ramsay argon (1894) |
| 8 | Causal intervention and controls | John Snow and cholera (1854) | Semmelweis (1847) | Pasteur vs Pouchet |
| 9 | Extrapolation to another system | [informatics] ML models of superconductor Tc | Thalidomide across species | TGN1412 (Thin) |
| 10 | Resolving power | [informatics] ML formation energy vs stability margin | Ether and the speed of light | Tycho's parallax and Bessel |

Chemistry or materials flavour: #1 A/B/C, #2 B/C, #5 A/B/C, #7 A/C, plus the informatics episodes in #6, #9, #10.

---

## 1. Fit vs test
**Check:** Was the data used to build or tune the theory, or could it have refuted it? dof = observables - fitted parameters; dof 0 is calibration.

**A. [informatics] DFT functionals PBE, B3LYP, PBE0 (+ dispersion)**
- Rivals: PBE (no fitted parameters), B3LYP (3 parameters fitted to a reference set, Becke 1993), PBE0 (25% exact exchange from an argument, not a fit), B3LYP-D3 (reduces_to B3LYP when the dispersion term is off).
- Claims: ParametersFitted vs NoFittedParameters (contradicts); ExactExchangeMixed; DispersionIncluded.
- Observations: G2 atomization energies (the fitting set), reaction barrier heights, non-covalent complexes (S22), solid band gaps, lattice constants, the GMTKN55 benchmark (2017) (v).
- Hidden assumptions: Born-Oppenheimer; basis set or cutoff converged; reference data accurate; pseudopotentials transferable.
- Right answer: a good score on the fitting set is calibration (dof 0). The real test is the out-of-set data, where B3LYP's documented failures (dispersion, barriers) show up (v).

**B. Bohr's atom (1897-1925)**
- Rivals: Thomson plum pudding, Rutherford classical nucleus, Bohr (reduces_to classical at large n).
- Observations: Geiger-Marsden large-angle scattering, Balmer lines, Pickering-Fowler lines read as He+ (Evans 1913), classical collapse of the orbiting electron (forbids classical Rutherford), Franck-Hertz, helium spectrum (Bohr fails) (v).
- Hidden assumptions: Coulomb law at atomic scale; E = h nu for emission; spectra independent of the source.
- Right answer: Balmer's formula is a fit (calibration); Bohr's derived Rydberg constant is a test; helium exposes the limit.

**C. Mendeleev's periodic law (1869-86)**
- Rivals: Prout's integer-weight hypothesis, Newlands' octaves, Meyer's curve, Mendeleev's table.
- Observations: gallium (1875), scandium (1879), germanium (1886) match predicted properties; tellurium/iodine order inversion; noble gases (not predicted); rare-earth trouble; Moseley's atomic number (1913) (v).
- Hidden assumptions: atomic weights accurate; elements are distinct substances; chemical similarity carries over.
- Right answer: the arrangement of known elements is calibration; the new-element predictions are tests; his failed predictions are also on record. Thin on rival structure.

## 2. Crucial test between rivals
**Check:** Does one outcome separate the rivals? Is the set of rivals complete? Which step rules out which rival?

**A. Nature of light, Foucault 1850 and Duhem's critique**
- Rivals: Newton's corpuscular emission theory, Huygens-Fresnel wave theory, later the photon.
- Claims: LightIsParticles vs LightIsWaves; FasterInDenserMedium vs SlowerInDenserMedium (contradicts); TransverseOscillation; EtherExists.
- Observations: Young's double slit (1801), Arago/Poisson spot (1818-19), polarization (transverse), Foucault and Fizeau light speed in water (1850), photoelectric effect (1887-1905), Compton (1923) (v).
- Hidden assumptions: the speed measurement (rotating mirror) is valid; the ether exists; classical mechanics holds for particles.
- Right answer: Foucault killed Newton's emission theory, not "all particle theories". The photoelectric effect then killed the classical wave, so the two-rival set was not complete.

**B. Meselson-Stahl (1958)**
- Rivals: conservative, semiconservative (Watson-Crick), dispersive (Delbruck).
- Claims: StrandsSeparate; ParentKeptIntact; NewStrandUsesTemplate.
- Observations: E. coli grown in heavy nitrogen (15N) then moved to light (14N); generation 1 = one intermediate band; generation 2 = intermediate + light bands in equal amounts; heat-denatured generation 1; mixed-generation control (v). Density read by CsCl centrifugation.
- Hidden assumptions: band position reflects density; the 15N label does not change replication; the DNA is not fragmented in ways the authors did not know.
- Right answer: semiconservative. Generation 1 kills conservative only (semiconservative and dispersive both predict "intermediate"); generation 2 kills dispersive. A good graph shows that generation 1 alone is NOT enough.

**C. Lavoisier vs phlogiston (1770s-80s)**
- Rivals: Stahl's phlogiston, phlogiston with negative weight, Lavoisier's oxygen.
- Observations: metals gain weight on calcination, a sealed vessel loses about one fifth of its air, mercury calx gives "dephlogisticated air" (Priestley 1774), water synthesis (Cavendish, Lavoisier), respiration (v).
- Hidden assumptions: mass is conserved; vessels are sealed; balance accuracy.
- Right answer: oxygen. Phlogiston survived only through an ad hoc auxiliary (negative weight).

## 3. Blame among auxiliaries (Duhem-Quine)
**Check:** When a prediction fails, does blame go to the right part of the composed claim?

**A. Newtonian gravity's two anomalies: Uranus (1846) and Mercury (1859)**
- Rivals: Newton + Neptune, Newton + Vulcan, Newton with Hall's exponent (1894), Newton with an oblate Sun, General Relativity.
- Claims: InverseSquareLaw; NoUnseenPlanets; SunIsSpherical; EphemerisCorrect (the blame goes to different parts in each anomaly).
- Observations: Uranus residuals (Bouvard 1821), Neptune sighted near the predicted spot (Galle 1846), Mercury precession 38 arcsec/century (Le Verrier 1859), re-estimated 43 (Newcomb 1882), Vulcan transit searches (null), 1919 light bending, solar oblateness measurements (v). Modern: GR term 42.98 arcsec/century, observed total 574.10 +- 0.65 against predicted 575.31.
- Hidden assumptions: ephemerides and star positions accurate; Newton holds in the outer solar system; light travels straight.
- Right answer: blaming "no unseen planet" was right for Uranus and wrong for Mercury, where the law itself changed (GR). Same shape, opposite answer. Hall's exponent (reported as 2.00000016) is one free number tuned to one observable, so dof 0, calibration only.
- Still to check: whether Hall's law was refuted by other bodies; whether Einstein used Mercury while building GR (the "old evidence" debate).

**B. Solar neutrino problem (1968-2002)**
- Rivals: solar model right + neutrino oscillation; solar model wrong (cooler core); detector wrong (chlorine efficiency).
- Observations: Homestake (about a third of the prediction), Kamiokande, SAGE/GALLEX, SNO charged-current vs neutral-current (2001-02), KamLAND reactor (2003), helioseismology (v).
- Hidden assumptions: detector efficiency (Davis's calibrations); no oscillation in the standard model; solar steady state.
- Right answer: neutrino oscillation (Nobel 2002, 2015).

**C. OPERA faster-than-light neutrinos (2011-12)**
- Rivals: relativity + timing fault, genuine superluminal neutrinos, a shortcut through extra dimensions.
- Composed claim: "neutrinos travel at or below light speed" (relativity) + the timing chain (GPS clock, fibre link, electronics) + the distance (730 km, +-20 cm).
- Observations: neutrinos arrived about 60 ns early (revised 57.8 ns), 6.2 sigma, 15,223 events; the Cohen-Glashow energy-loss argument; SN1987A timing; ICARUS, Borexino, LVD agreed with light speed (June 2012); a loose fibre connection (-73 ns, made neutrinos look faster) and an electronics clock above its 10 MHz spec (the other way, size not found) (v). Final: 6.5 +- 15 ns, consistent with zero.
- Hidden assumptions: GPS synchronisation; fibre delay; baseline length.
- Right answer: blame the timing chain, not relativity. Thin: few rival models.

## 4. Hidden assumption in the measurement
**Check:** What does the observation itself assume? Does the verdict flip when that assumption is dropped? (Three-way sensitivity: declared / discovered / suspected.)

**A. Continental drift to plate tectonics (1912-1970)**
- Rivals: fixed continents with land bridges, contracting Earth, expanding Earth, Wegener's drift, seafloor spreading (plate tectonics).
- Claims: ContinentsMoveHorizontally vs ContinentsFixed (contradicts); EarthRadiusConstant (contradicts expansion); OceanFloorCreatedAtRidges; MantleConvection.
- Observations: coastline fit (Bullard 1965), fossil and rock matches (Glossopteris, Mesosaurus), glacial striations, paleomagnetic polar-wander paths (Runcorn, Irving), symmetric magnetic stripes (Vine-Matthews 1963), seafloor age pattern (1968+), GPS (v).
- Hidden assumptions (with status): rock magnetization records the ancient field (declared); the field was an axial dipole (declared); self-reversing rocks (suspected, found rare); field reversals (discovered, first an objection, then evidence) (v).
- Right answer: plate tectonics; constant radius; the paleomagnetic assumptions held up.

**B. Baade's two Cepheid populations (1952)**
- Rivals: one period-luminosity law (H0 about 500, universe about 2 Gyr), two populations (distance scale doubled), later calibrations.
- Observations: Hubble 1929 velocity-distance, M31 Cepheid distances, RR Lyrae not seen at the expected brightness (200-inch), radiometric Earth age, globular-cluster ages (v).
- Hidden assumptions: all Cepheids share one law; no dust; Cepheid identification.
- Right answer: the one-law assumption was false, and the "universe younger than Earth" paradox went away.

**C. Mesosomes (1950s-80s)**
- Rivals: real organelle (proposed roles: cell division, DNA replication, respiration), fixation artifact.
- Observations: electron micrographs show folded membrane structures (seen from 1953, named 1960); studies in the late 1970s traced them to fixation damage; cryofixation work in the 1980s (Dubochet 1983, Ryter 1988) found none in living cells; osmium vs glutaraldehyde; freeze-fracture (v).
- Hidden assumptions: chemical fixation preserves the cell as it was.
- Right answer: artifact. The images were reproducible, so reproducibility did not save the claim. Thin: two rivals. Still to check: names and years against the primary papers.

## 5. Conflicting results and replication
**Check:** Who is wrong, the original or the replication? Is the standard for "a working experiment" circular?

**A. LK-99 (2023)** (materials)
- Rivals: room-temperature superconductor; Cu2S-impurity artifact; ferromagnetic/diamagnetic insulator.
- Claims: StructureIsCuSubstitutedPbApatite; FlatBandsGiveSuperconductivity; SampleContainsCu2S; ResistivityDropIsSuperconducting vs IsStructuralTransition (contradicts).
- Observations: resistivity drop near 104 C and a levitation video (Lee, Kim, Kwon, arXiv 2307.12008); DFT flat bands (Griffin, arXiv 2307.16892); replications showing a Cu2S transition near 385 K; ferromagnetic/diamagnetic magnetisation; insulating pure single crystals (Max Planck Stuttgart); no zero resistance; phase purity by XRD (v).
- Hidden assumptions: the idealised DFT structure represents the real sample (suspected, then discovered false); the sample is phase-pure (discovered false); contacts are reliable.
- Right answer: not a superconductor (Nature news, 16 Aug 2023). The DFT result says what an idealised structure could do, not what the sample did, so a good graph keeps it from counting as evidence about the sample.

**B. Cold fusion (Fleischmann-Pons, 23 March 1989)**
- Rivals: nuclear fusion in palladium, chemical or calorimetry artifact, measurement error.
- Claim: palladium cathode in heavy water gave excess heat (10-20% of input) plus neutrons and tritium. At the claimed heat levels about 10^12 neutrons/second would be expected and were not seen.
- Observations: excess heat; neutron claims (Georgia Tech retracted in 3 days, detector false positives); tritium (Texas A&M, later questioned as contamination); null results at Caltech and many others; DOE 1989 not convincing; DOE 2004 reviewers split, most said not repeatable (v).
- Hidden assumptions: calorimeter calibration; gas recombination inside the cell; neutron detector false positives; thermometer wiring (Texas A&M).
- Right answer: not supported. The graph must keep the positive replications visible and justify discounting them.

**C. Arsenic life GFAJ-1 (2010-12)**
- Rivals: arsenic replaces phosphorus in DNA; trace phosphate contamination; arsenate bound but not in the backbone.
- Observations: growth on arsenate without added phosphate, NanoSIMS, DNA gel and elution, replication studies (Reaves, Erb 2012), the 2025 retraction (v).
- Hidden assumptions: media phosphate below the threshold; washing removes free arsenate; arsenate-DNA is stable.
- Right answer: not supported.

## 6. Search and selection effects
**Check:** How many places were searched? A "local" significance is not the "global" one.

**A. [informatics] GNoME and high-throughput materials discovery (2023-24)**
- Rivals: "2.2M structures, 380k stable, a big discovery"; "mostly not new, useful or makeable"; "stability on an incomplete 0 K hull is not stability".
- Claims: StableOnDFTHull; CompoundIsNovel; CompoundIsSynthesizable; CompoundIsUseful.
- Observations: DFT hull energies over millions of candidates; A-Lab synthesis (41 of 58 targets); the critique of A-Lab phase identification (2024); expert review of samples (Cheetham & Seshadri 2024); reports of already-known compounds (v).
- Hidden assumptions: a 0 K PBE hull approximates real stability; the hull is complete; automated XRD refinement assigns phases correctly.
- Right answer: only the documented critiques count. This is the riskiest episode because it is partly contested. Use the strictest source check, and drop to B and C if it cannot be pinned down.

**B. 750 GeV diphoton excess (2015-16)**
- Rivals: background fluctuation, spin-0 resonance, spin-2 graviton.
- Observations: December 2015, ATLAS 3.9 sigma local (about 2.0-2.3 global), CMS 2.6 local (about 1.2 global) at 13 TeV; a CMS 8+13 TeV combination 3.4 local, 1.6 global; other channels (ZZ, Z-gamma, WW, dijet; null); August 2016 more data (ATLAS 15.4, CMS 12.9 fb^-1), no excess (v). About 500 papers proposed new particles.
- Hidden assumptions: background function shape; width assumption; luminosity.
- Right answer: statistical fluctuation. A good graph treats "3.9 sigma local" as insufficient and reports the search-space size. Global values differ by paper and width assumption; pick one source and cite it.

**C. Higgs discovery (2012), the contrast case**
- Rivals: no Higgs, Standard Model Higgs, fluctuation.
- Observations: ATLAS and CMS diphoton, ZZ to four leptons, WW, 2011 vs 2012 data, the Tevatron excess, later spin/parity and coupling measurements (v).
- Hidden assumptions: the same background-modelling assumptions as B.
- Right answer: real. The same kind of analysis as B, with the opposite outcome.

## 7. Exploratory discovery (record vs reading)
**Check:** Record and interpretation are kept apart (R4). The claim stays at the level the record supports. Systematics are listed.

**A. Quasicrystals (Shechtman 1982)** (materials)
- Rivals: Pauling's twinned cubic crystal, quasicrystal (Levine-Steinhardt), icosahedral glass, large-cell approximant.
- Claims: LongRangeOrderIsPeriodic vs QuasiperiodicOrderExists (contradicts); TenFoldSymmetryImpliesTwinning; SharpSpotsMeanLongRangeOrder.
- Observations: Al-Mn electron diffraction (1982), HRTEM, single-grain X-ray from stable Al-Cu-Fe and Al-Pd-Mn (1987), no twin signatures, natural icosahedrite (2009), golden-ratio peak spacing (v).
- Hidden assumptions: kinematic diffraction; single grain; no multiple-scattering artifact.
- Right answer: quasicrystals exist (Nobel Prize in Chemistry 2011). A good graph keeps the diffraction pattern as the record and treats the readings as `interprets` edges.

**B. Penzias-Wilson, Holmdel 6 m horn antenna (1964-65)**
- Rivals: Big Bang relic (Dicke, Peebles, Roll, Wilkinson), steady state, instrument or terrestrial noise.
- Observations: excess antenna noise of about 3.5 K at 7.35 cm (4080 MHz) after taking out 2.3 K (atmosphere) and 0.9 K (instrument), same day and night and direction; radio interference, Earth, Sun, Galaxy and pigeon droppings checked (noise stayed); Dicke's 3.2 cm measurement; COBE spectrum (1990); McKellar 1941 (about 2.3 K, no cosmological reading) (v).
- Hidden assumptions: the atmosphere and receiver temperatures are right; the horn efficiency is right.
- Right answer: the CMB. Their own paper made no cosmological claim. Still to check: the paper's stated error bar.

**C. Rayleigh-Ramsay argon (1894)**
- Rivals: atmospheric nitrogen is contaminated, chemical nitrogen is contaminated, a new heavy component.
- Observations: air nitrogen density about 0.5% higher than chemical nitrogen, Cavendish's 1785 residual bubble, Ramsay's magnesium absorption, new spectral lines, the specific-heat ratio (monatomic) (v).
- Hidden assumptions: balance accuracy; gas purity.
- Right answer: a new element, argon (Nobel 1904).

## 8. Causal intervention and controls
**Check:** Is there a real control? Which confounders are ruled out and how? Does the claimed cause match what the intervention actually changed?

**A. John Snow and cholera, London 1854**
- Rivals: miasma, waterborne (Snow), person-to-person contact, Farr's elevation theory.
- Claims: DiseasePassesViaWater; DiseasePassesViaAir; DiseasePassesByContact.
- Observations: the Broad Street cluster map; brewery workers (own well and beer, few deaths); the workhouse (535 inmates, 5 deaths); the Hampstead widow; Lambeth vs Southwark & Vauxhall (about 37 vs 315 deaths per 10,000 houses); pump-handle timing (outbreak already falling) (v).
- Hidden assumptions: death records accurate; households attributed to the right company; the two groups are otherwise alike.
- Right answer: waterborne. The handle removal on its own is not a clean test. His mechanism was vague since germ theory was not established.

**B. Semmelweis, Vienna General Hospital (1847)**
- Rivals: cadaverous particles, overcrowding, climate, birth position, psychological ("priest bell") theory.
- Observations: First Clinic (doctors and students) mortality 6.9-15.8% per year (1841-46) vs Second Clinic (midwives) 2.0-7.6%; overcrowding (Second Clinic was more crowded); adjacent clinics (not climate); birth position changed (no effect); chlorinated-lime handwashing from mid-May 1847, First Clinic monthly mortality 18.3% (April) to 2.2% (June) to 1.2% (July) (v).
- Hidden assumptions: the clinics differ only in staff; records are comparable.
- Right answer: the intervention worked. A good graph separates "the intervention reduced deaths" from "the stated mechanism is right". Still to check: 1847-48 clinic-by-clinic figures, and other changes made that year.

**C. Pasteur vs Pouchet (1859-62)**
- Rivals: spontaneous generation, airborne germs, heat-resistant spores.
- Observations: swan-neck flasks, mountain-air flasks, Pouchet's hay infusions that survived boiling, Tyndall's spore finding (1870s) (v).
- Hidden assumptions: boiling sterilises; the infusions are comparable.
- Right answer: germs from the air. Pasteur's controls were right, and Pouchet's hay result had a real explanation.

## 9. Extrapolation to another system
**Check:** What links the model system to the target? Is the similarity argued or assumed (the "extrapolator's circle")?

**A. [informatics] ML models of superconductor Tc (Meredig et al. 2018)**
- Rivals: "the model generalises to new materials"; "it only interpolates inside known families"; "random-split scores are inflated by near-duplicates".
- Claims: TrainAndTestExchangeable; CompositionFeaturesCaptureTc; FamilyDeterminesTc.
- Observations: random k-fold score; leave-one-cluster-out holding out cuprates; holding out iron-based; holding out other families; feature importance; a prospective test, if available (v).
- Hidden assumptions: the database is representative; Tc is defined consistently; duplicates are handled.
- Right answer: a good random-split score does not carry over to new chemical families. The missing premise is "the targets are as similar to the training set as the test compounds were".

**B. Thalidomide across species**
- Rivals: parent drug is the teratogen, a metabolite is, the target protein (cereblon) differs by species.
- Observations: no malformations in mice and rats, malformations in rabbits and primates, human outcome (1957-61), chick-embryo and zebrafish results, cereblon binding (Ito 2010), SALL4 degradation (2018) (v).
- Hidden assumptions: equivalent dose; same metabolism; same developmental window.
- Right answer: species differ in the target, so rodent safety did not carry over.

**C. TGN1412 first-in-human, 13 March 2006, London**
- Rivals: macaque safety carries over, the target is not shared.
- Observations: cynomolgus macaques as the main safety species with no toxicity seen; human dose 0.1 mg/kg, about 1/500 of the highest macaque dose; 6 volunteers on drug, 2 on placebo; all six hospitalised within 12-16 hours, symptoms from about 50 minutes, at least four with multiple organ dysfunction; macaque CD4+ effector memory T cells lack CD28, the drug's target (Eastwood 2010) (v).
- Hidden assumptions: the same target expression in both species.
- Right answer: safety in macaques did not carry over because the target was not shared. Thin: two rivals.

## 10. Resolving power: can the data tell the rivals apart?
**Check:** Is the experiment precise enough to separate the rivals? If two rivals predict the same observable for ALL possible data, they are empirically equivalent.

**A. [informatics] ML formation energies vs the stability margin (Bartel et al. 2020)**
- Rivals: "low formation-energy error means stability can be predicted"; "the margin is as small as the error, so it cannot"; structure-based vs composition-only models.
- Claims: LowMAEImpliesStabilityAccuracy; StabilityDependsOnEnergyAboveHull; DFTErrorsCancelInDifferences.
- Observations: formation-energy error on held-out data; stability classification metrics; the spread of hull distances compared with the errors; structure-based vs composition-only behaviour; false "stable" predictions (v).
- Hidden assumptions: DFT energies are the ground truth; the hull has all competing phases; the test set matches the discovery set.
- Right answer: an accurate formation energy does not mean accurate stability, because the error is as large as the margin that decides it.

**B. The ether and the speed of light (1810-1938)**
- Rivals: stationary ether, ether drag, emission theory, Lorentz contraction (Lorentz ether theory), special relativity.
- Claims: EtherExists; LightSpeedIndependentOfSource; LengthContracts; Lorentz ether theory and special relativity as `implies` both ways (empirically equivalent).
- Observations: stellar aberration, Fizeau water 1851, Michelson-Morley 1887, Kennedy-Thorndike 1932, Ives-Stilwell 1938, de Sitter's double stars, Sagnac, Trouton-Noble; the Kaufmann-Bucherer mass-velocity experiments (1901-14), where early data could not separate the rivals and later ones could (v).
- Hidden assumptions: only the two-way speed is measured; the clock-synchronisation convention.
- Right answer: relativity was preferred on simplicity; no experiment can separate it from the Lorentz ether theory. "Decisive" verdicts in 1908 were premature.

**C. Tycho's parallax and Bessel's 61 Cygni (1838)**
- Rivals: geocentric, Tychonic, Copernican.
- Observations: no parallax at the arcminute precision of Tycho's instruments, Venus phases, Jupiter's moons, stellar aberration (Bradley 1729), Bessel's parallax of about 0.3 arcsec (v).
- Hidden assumptions: the apparent size of star discs is real (an artifact, as Galileo's telescope and Airy later showed); stars are at finite distance.
- Right answer: the null result at that precision could not refute the Copernican view. The signal is under an arcsecond and the instruments were about 200 times too coarse.

---

## What the current core can already express
Mapping from the Earth graph to `Empirica/Basic.lean`:

| Earth graph piece | In today's core | Gap |
|---|---|---|
| Rival, claim | `Theory` | none |
| Observation | `Experiment` (raw `observation`) | numbers live in prose |
| `composed_of` | `entails [parts] model` | blame flowing down to a part is not computed |
| `predicts`, `forbids` | `entails` + `interprets`; `nogood` | no values or tolerances |
| `contradicts`, `implies` | `Edge.contradicts`, `Edge.implies` | none |
| `relies_on` (declared / suspected / discovered) | only a plain premise | **needs a new edge** (hits #4, #5, #6, #10 hardest) |
| `reduces_to` | none | **needs a new edge** (#1, #3) |
| dof, search space, control, resolving power | none | needs new machinery (#1, #6, #8, #9, #10) |

The graphs can be drawn now with what exists. The gaps are the next design step.

## Coverage and honest limits
- Fields: chemistry and materials (#1, #2, #5, #7), computational materials informatics (#1, #6, #9, #10), physics and astronomy (#2, #3, #4, #10), geology (#4), biology and medicine (#2, #8, #9).
- Not covered: statistical paradoxes (Simpson), explanatory asymmetry (flagpole), circularity, unfalsifiable claims. Add later if the core grows to need them.
- Overlaps: #2 with #3 (both involve rivals), #4 with #5 (a hidden assumption often explains a failed replication, as in LK-99), #6 with #10. Treat each episode as the main case for its own check and note the second category rather than duplicating it.
- The informatics episodes are methods papers or recent, partly contested episodes rather than famous controversies. They are included on purpose and need the strictest source check, especially #6 A.
- Dropped from the first list because they are not Earth-style (too few rivals or observations): dead salmon fMRI, Eddington 1919 as a main case, and the single-trial framing of Kaufmann-Bucherer (now inside #10 B).
- Shape of the Earth is out because it is Nilesh's example.

## How this was built
- Philosophy sources (Stanford Encyclopedia of Philosophy): experiment in physics and in biology, underdetermination, confirmation, reproducibility, scientific method, 20th-century explanation.
- AI-reasoning sources: arXiv 2604.18805 (epistemic operations and failure patterns).
- Episodes that were in the earlier drafts (Mercury, Meselson-Stahl, OPERA, mesosomes, cold fusion, 750 GeV, Penzias-Wilson, Semmelweis, TGN1412, Kaufmann-Bucherer): facts and numbers come from Wikipedia pages read through a summarising tool, plus a few web searches.
- The new episodes (v3, 2026-10-18) come from general knowledge and have NOT been source-checked. Treat every number and date marked "(v)", and everything in the informatics episodes, as unconfirmed until checked against the primary paper.
