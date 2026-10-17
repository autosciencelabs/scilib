# Empirica: taxonomy of 10 reasoning situations, with one real episode each

Status: DRAFT v1 (2026-10-17). Built from research, not from an official standard. No agreed taxonomy of "scientific phenomena" exists (see "How this was built").

**What is decided and what is not (Parth, 2026-10-17):**
- DECIDED (as the working plan): the 10 **categories** (situations).
- NOT DECIDED: the **examples**. The episode listed under each category is only an illustration that shows what the category looks like. Examples will be broadened later: each category can hold many episodes, and the pool grows by classifying more episodes into these categories (for example, only one chemistry episode is listed now; more will be added).

## The idea in one line
Each entry is a **situation where evidence meets a claim and reasoning can go wrong in a specific way**. The verifier must catch that specific way. Each category has an illustrative real episode with a known right answer, so a verifier's score on it can be checked. An episode only belongs in the pool if its right answer is documented.

## Index

| # | Category (the check) | Illustrative episode (not final) | Field | Known right answer |
|---|---|---|---|---|
| 1 | Fit vs test | Mercury's perihelion: GR vs a tuned Newtonian law | Gravity | GR was a test; the tuned law was calibration only |
| 2 | Crucial test between rivals | Meselson-Stahl DNA replication (1958) | Molecular biology | Semiconservative; conservative and dispersive ruled out |
| 3 | Blame among auxiliaries | OPERA "faster-than-light" neutrinos (2011-12) | Particle physics | Blame fell on two hardware faults, not relativity |
| 4 | Hidden assumption in the measurement | Bacterial mesosomes (1950s-80s) | Microbiology | An artifact of chemical fixation |
| 5 | Conflicting results and replication | Cold fusion (1989) | Electrochemistry / nuclear | Claim not supported; replications failed |
| 6 | Search and selection effects | 750 GeV diphoton excess (2015-16) | Particle physics | Statistical fluctuation |
| 7 | Exploratory discovery (record vs reading) | Penzias-Wilson antenna noise (1964-65) | Cosmology | The noise was the cosmic microwave background |
| 8 | Causal intervention and controls | Semmelweis and childbed fever (1847) | Medicine | Hand-washing worked; his stated cause was incomplete |
| 9 | Extrapolation to another system | TGN1412 first-in-human trial (2006) | Pharmacology | Monkey safety did not carry over to humans |
| 10 | Resolving power: can the data tell the rivals apart? | Kaufmann-Bucherer electron experiments (1901-14) | Relativity | Early data could not separate the rivals; later ones could |

---

## 1. Fit vs test
**Check:** Was the data used to build or tune the theory, or could it have refuted it? dof = observables - fitted parameters; dof 0 is calibration.
**Episode:** Mercury's perihelion precession.
- Theories: General Relativity (GR); Newton's law with an adjusted exponent (Hall, 1894); an unseen inner planet "Vulcan" (Le Verrier).
- Experiment record: unexplained precession 38 arcsec/century (Le Verrier 1859), re-estimated 43 (Newcomb 1882). Modern: GR term 42.98, observed total 574.10 +- 0.65 against predicted 575.31.
- Fitting: Hall's exponent (reported as 2.00000016) is one free number tuned to one observable, so dof 0. GR has no free parameter for this, so dof 1.
- Right answer: Hall's law = calibration only. GR = a genuine test. No Vulcan was ever found.
- Still to check: whether Hall's law was refuted by other bodies (not confirmed in my reading); whether Einstein used Mercury while building GR (the "old evidence" debate).

## 2. Crucial test between rivals
**Check:** Does one outcome separate the rivals? Is the set of rivals complete? Which step rules out which rival?
**Episode:** Meselson-Stahl (1958).
- Theories: conservative, semiconservative (Watson-Crick), dispersive (Delbrück).
- Experiment: E. coli grown in heavy nitrogen (15N), moved to light (14N), DNA density read by CsCl centrifugation.
- Records: generation 1 = one intermediate band. Generation 2 = two bands, intermediate and light, in equal amounts.
- Logic: generation 1 kills conservative only (semiconservative and dispersive both predict "intermediate"). Generation 2 kills dispersive.
- Right answer: semiconservative.
- A good graph shows that generation 1 alone is NOT enough.
- Still to check: exact band densities (need the 1958 PNAS paper); the SEP note that the DNA was fragmented in ways the authors did not know.

## 3. Blame among auxiliaries (Duhem-Quine)
**Check:** When a prediction fails, does blame go to the right part of the composed claim?
**Episode:** OPERA neutrinos.
- Composed claim: "neutrinos travel at or below light speed" (relativity) + the timing chain (GPS clock, fibre link, electronics) + the distance (730 km, +-20 cm).
- Experiment record: neutrinos arrived about 60 ns early (revised 57.8 ns), 6.2 sigma, 15,223 events.
- Blame result: a loose fibre connection (-73 ns, made neutrinos look faster) and an electronics clock running above its 10 MHz spec (works the other way, size not found).
- Final: 6.5 +- 15 ns, consistent with zero. ICARUS, Borexino, LVD agreed with light speed (June 2012).
- Right answer: blame the timing chain, not relativity.
- Contrast case (not chosen): Uranus -> Neptune, where blaming an auxiliary was correct, versus Mercury -> Vulcan, where it was not.

## 4. Hidden assumption in the measurement
**Check:** What does the observation itself assume? Does the verdict flip when that assumption is dropped? (Three-way sensitivity: declared / discovered / suspected.)
**Episode:** Mesosomes.
- Record: electron micrographs of bacteria show folded membrane structures (seen from 1953, named 1960).
- Reading: real organelle (proposed roles: cell division, DNA replication, respiration).
- Hidden assumption: chemical fixation for microscopy preserves the cell as it was.
- Discovery: studies in the late 1970s found they come from fixation damage. Cryofixation work in the 1980s (Dubochet 1983, Ryter 1988) found none in living cells.
- Right answer: artifact. Note that the images were reproducible, so reproducibility did not save the claim.
- Still to check: names and years against the primary papers.

## 5. Conflicting results and replication
**Check:** Who is wrong, the original or the replication? Is the standard for "a working experiment" circular?
**Episode:** Cold fusion (Fleischmann-Pons, 23 March 1989).
- Claim: palladium cathode in heavy water gave excess heat (10-20% of input) plus neutrons and tritium.
- Conflict with theory: at claimed heat levels, about 10^12 neutrons/second would be expected and were not seen.
- Replications: Caltech and many others negative; Texas A&M (heat, tritium) later questioned as contamination; Georgia Tech neutron claim retracted in 3 days (detector false positives).
- Systematics raised: gas recombination inside the cell, calibration shifts, bad thermometer wiring (Texas A&M).
- Panels: DOE 1989 not convincing; DOE 2004 reviewers split, most said not repeatable.
- Right answer: not supported. The graph must keep the positive replications visible and justify discounting them.

## 6. Search and selection effects
**Check:** How many places were searched? A "local" significance is not the "global" one.
**Episode:** 750 GeV diphoton excess.
- Record: December 2015, ATLAS 3.9 sigma local (about 2.0-2.3 global), CMS 2.6 local (about 1.2 global) in 13 TeV data. A CMS 8+13 TeV combination gave 3.4 local, 1.6 global.
- Theory: about 500 papers appeared proposing new particles.
- August 2016: more data (ATLAS 15.4, CMS 12.9 fb^-1) did not confirm.
- Right answer: statistical fluctuation.
- A good graph treats "3.9 sigma local" as insufficient and reports the search-space size.
- Note: global values differ by paper and width assumption. Pick one source and cite it.

## 7. Exploratory discovery (record vs reading)
**Check:** Record and interpretation are kept apart (R4). The claim stays at the level the record supports. Systematics are listed.
**Episode:** Penzias and Wilson, Holmdel 6 m horn antenna.
- Record: excess antenna noise of about 3.5 K at 7.35 cm wavelength (4080 MHz), after taking out 2.3 K (atmosphere) and 0.9 K (instrument). Same day and night, same direction.
- Systematics checked: radio interference, Earth, Sun, Galaxy, pigeon nests and droppings (cleaned; noise stayed).
- Readings: Big Bang relic (Dicke, Peebles, Roll, Wilkinson, Princeton) vs steady state. Penzias and Wilson's own paper made no cosmological claim.
- Right answer: Big Bang relic radiation (CMB). Earlier hint: McKellar 1941, about 2.3 K, with no cosmological reading.
- Still to check: the paper's stated error bar.

## 8. Causal intervention and controls
**Check:** Is there a real control? Which confounders are ruled out and how? Does the claimed cause match what the intervention actually changed?
**Episode:** Semmelweis, Vienna General Hospital.
- Record: First Clinic (doctors and students) mortality 6.9-15.8% per year (1841-46); Second Clinic (midwives) 2.0-7.6%.
- Hypotheses dropped: overcrowding (Second Clinic was more crowded), climate (clinics adjacent), birth position (changed, no effect).
- Intervention: chlorinated-lime hand washing from mid-May 1847. First Clinic monthly mortality 18.3% (April) -> 2.2% (June) -> 1.2% (July).
- His stated cause ("cadaverous particles") was vague, since germ theory did not exist yet.
- Right answer: the intervention worked. A good graph separates "the intervention reduced deaths" from "the stated mechanism is right".
- Still to check: 1847-48 clinic-by-clinic figures (not found), and other changes made that year.

## 9. Extrapolation to another system
**Check:** What links the model system to the target? Is the similarity argued or assumed (the "extrapolator's circle")?
**Episode:** TGN1412, 13 March 2006, London.
- Preclinical: cynomolgus macaques as the main safety species. No animal toxicity of this kind seen.
- Human dose: 0.1 mg/kg, about 1/500 of the highest macaque dose. 6 volunteers received drug, 2 placebo.
- Outcome: all six hospitalised within 12-16 hours; at least four had multiple organ dysfunction; symptoms began about 50 minutes after dosing.
- Why the extrapolation failed: macaque CD4+ effector memory T cells lack CD28, the drug's target (Eastwood 2010). Human ones have it.
- Right answer: safety in macaques did not carry over because the target was not shared. The key missing premise: "the target is expressed the same way in both species".

## 10. Resolving power: can the data tell the rivals apart?
**Check:** Is the experiment precise enough to separate the rivals? If two rivals predict the same observable for ALL possible data, they are empirically equivalent.
**Episode:** Electron mass vs velocity, Kaufmann-Bucherer-Neumann.
- Rivals: Abraham (rigid electron), Lorentz-Einstein, Bucherer-Langevin.
- Records: Kaufmann (1905-06) reported data favouring Abraham. Bucherer (1908) reported data favouring Lorentz-Einstein, widely treated as decisive.
- Later view: those results were not precise enough to separate the rivals; sufficient accuracy came about 1940.
- Separate case: Lorentz ether theory vs special relativity are experimentally equivalent (two-way light speed), so no data can separate them. Preference rests on simplicity.
- Right answer: "decisive" verdicts in 1908 were premature. A good graph flags the missing resolving power and flags the equivalence as untestable.
- Still to check: Kaufmann's and Bucherer's actual accuracies and predictions (not found in my reading).

---

## Coverage and honest limits
- Fields touched by the illustrative episodes: gravity, molecular biology, particle physics (x2), microbiology, electrochemistry, cosmology, medicine, pharmacology, relativity. Chemistry appears only once (#5). That is expected for now: the pool will grow by adding more episodes per category, including more chemistry, not by swapping the categories.
- Not covered: statistical paradoxes (Simpson), explanatory asymmetry (flagpole), circularity, unfalsifiable claims, theory succession via limits (`reduces_to`). Add later if the core grows to need them.
- Several episodes (#1, #3, #10) overlap in theme with #2 or #6. Treat each as the main case for its own check.

## What the current core can already express
| Fits now (`entails`, `interprets`, `absurd`) | Needs new machinery |
|---|---|
| 2 rivals, 3 blame, 4 hidden assumptions (partly), 5 conflict (partly) | 1, 6: numbers (dof, search space) |
| 7 record vs reading, 10 equivalence | 8, 9: control and similarity premises; 10: resolving power |

## How this was built
- Philosophy sources (Stanford Encyclopedia of Philosophy): experiment in physics and in biology, underdetermination, confirmation, reproducibility, scientific method, 20th-century explanation. Their case lists supplied episodes 2-6, 8-9 candidates.
- AI-reasoning sources: arXiv 2604.18805 (epistemic operations and failure patterns) and 2512.16969 (a workflow taxonomy, not used).
- Facts and numbers in each entry come from Wikipedia pages read through a summarising tool, plus a few web searches. Treat every number as "to verify against the primary paper" before it goes into a Lean file. The "Still to check" lines list known gaps.
