# CLAUDE.md: Scientific Reasoning Verifier

Project context for the scientific-reasoning verifier: Parth (the user) builds it, and Nilesh Trivedi (the mentor) designed the language.

## How to work with Parth
- Keep explanations **simple and short**. Use plain words, tables and small diagrams, and lead with the answer.
- Parth does not know Lean. Explain Lean-related things without assuming Lean knowledge.
- Skip long philosophy. Prefer concrete mappings to the mentor's files.
- Don't write code unless asked.

## Goal
Build a **verifier for scientific reasoning**, inspired by Lanyon AI: a tool that checks whether scientific reasoning is fair (real tests, visible assumptions, correct blame), not just whether the math is right.

**Nilesh's clarification (Slack, 2026-10-11):**
- The verifier is a **deterministic tool that grades any AI model** claiming to reason scientifically. It is not a scientist itself.
- The aim is to improve a scientist agent's **thinking skills on empirical concerns** (fit vs test, hidden assumptions, blame), not to prove theories true.
- Once the tool exists, model developers can use it as the **reward signal for RLVR** (RL with verifiable rewards) post-training, the way unit tests or Lean are used for code and math.
- So the checker must be deterministic: the same `.sci` input always gets the same score, with no LLM judge inside.

```
AI model ──writes reasoning as .sci──► Verifier (deterministic) ──► score / errors ──► RLVR reward
```

## The pipeline (core mental model)

```
Intent ──► Spec ──► Code ──► Proof ──► Reality
  (gap)    └──── Lanyon AI ─────┘      └─ Nilesh ─┘
```

| Step | Meaning | Who covers it |
|---|---|---|
| Intent → Spec | Turn words into a precise spec | Open gap. It can never be fully verified. Nilesh: LLMs only need to beat humans here, not be 100% correct. |
| Spec → Code → Proof | Code generated from one spec, plus a proof that it matches | **Lanyon AI** (verification) |
| Proof → Reality | Is the theory true about the world? | **Nilesh's language** (validation) |

**Key point:** in math, proof = truth. In science, a proof only means "IF the assumptions hold, THEN this follows". Experiments decide whether the assumptions hold, and that extra step is what this project works on.

### Lanyon AI: what they got right
These are company claims and not independently verified.
1. One formal spec generates both the code and the proof, so the two can't drift apart.
2. Proofs (Lean/Rocq) instead of tests, so every case is covered.
3. Physics-aware types (Length, Energy) catch nonsense at the spec stage.
4. An LLM proposes and a strict checker verifies (neurosymbolic).
5. They are honest that intent → spec is unsolved.

They do not cover intent → spec or proof → reality.

## Mentor's language: `.sci` (example file: ShapeOfEarth.sci)
Source files: `C:\Users\HP\Downloads\Untitled` (the `.sci` file) and `C:\Users\HP\Downloads\shape_of_earth_theory_graph.html` (the same file drawn as an interactive graph).

A file is a flat list of statements of 3 kinds: `use` (Lean import), `node` (theory or experiment) and `edge`.

### Design rules
- **R1. Composition, not inheritance.** Dots in names (`Geo.X`) are only namespaces. Cycles are allowed (reported, not rejected).
- **R2. Relations live only on edges.** Nodes hold intrinsic content only, so edges can be added or disputed later without editing nodes.
- **R3. Everything can be incomplete.** Each field can be prose, an expression, a Lean expression, a pinned Lean declaration, or `?` (a hole, like Lean's `sorry`). The formality level is derived, never declared.
- **R4. Observation is theory-laden.** An experiment separates what was **recorded** from what it is **interpreted** as. The interpretation is a set of `relies_on` edges.

### Node structs

**Theory** (any claim, tested or not; being proven or refuted is a computed status, not a node kind):
```
theory <Ns.Name> {
  statement:  "text"               // REQUIRED. The informal version (plain words)
  params:     { name: Type }       // optional. Free knobs fitted to data (e.g. r: Length)
  constants:  { name: value }      // optional. Fixed quantities (unused in the example)
  formal:     LeanRef | ?          // optional. The formal version (takes precedence over statement)
}
```

**LeanRef** (inside `formal`):
```
lean { module: "...", decl: "...", rev: "commit", status: unchecked | checked, fidelity: "name mapping" }
```

**Experiment** (an observation of the world, NOT the user's wishes):
```
experiment <Ns.Name> {
  record:       "text" | ?                  // what was literally seen (informal)
  observable:   name = expr : Type          // the quantity compared with theories (an interpretation)
  inputs:       { name: value ± err }       // optional. Other measured quantities
  systematics:  [ "text" ]                  // optional. Known non-statistical errors
  result:       value ± err | "text" | { name: value ± err }   // absent if planned
  status:       planned | performed
}
```

**Values:** `"text"` (informal) → `7.2 deg ± 1.5` (semi-formal) → `lean("...")` (formal) → `lean { status: checked }` (verified), or `?` for a hole. "Informal" is not a field; it is any field filled with words, mainly `statement` and `record`.

**Computed by the tool, never written in the file:** role (model if it has `composed_of`; background if it is a `relies_on` target; otherwise claim), formality level, verdict, and the list of holes.

### Edge structs
General form: `<Source> <relation> <Target | [Targets]> { attributes }`

| Relation | Meaning | Attributes | Rule the tool applies |
|---|---|---|---|
| `composed_of` | A is the conjunction of its parts | — | Predictions flow UP; blame flows DOWN to the parts |
| `implies` | If A then B | — | Chains; A→B plus B→A means equivalence |
| `contradicts` | Not both | — | Symmetric |
| `reduces_to` | A approaches B in a limit | `limit`, `error_bound` | Asymptotic, not logical. Old theories are kept as limits, not deleted |
| `predicts` | T says what E will show | `value`, `fitted`, `derivation`, `evidence` (asserted / cited / numeric / lean) | Compare with `result` |
| `forbids` | T says E cannot show an outcome | `value`, `derivation` | That outcome refutes T |
| `relies_on` | A is valid only if B holds | `status` (declared / suspected / discovered), `note` | Verdicts are computed 3 ways: declared only; plus discovered; plus suspected. If the verdict flips, the conclusion is theory-laden. |

### The mentor's key tricks
1. Experiments are nodes, which brings reality into the graph (Lean can't do this).
2. Rival theories live side by side; `contradicts` is an edge, not a crash.
3. Models are compositions of claims, so blame can go to the right part (the Duhem–Quine problem).
4. **dof = observables − fitted params.** dof = 0 means calibration, not a test.
5. Hidden assumptions are `relies_on` edges with a confidence status, and verdicts are checked for sensitivity to them.
6. Holes and prose are allowed, so ideas can be formalized gradually. Pure-informal nodes exist because science encodes claims before they are formalizable (e.g. wave–particle duality, probability amplitudes).
7. Roles (such as "principle") are derived from the edges, not declared.
8. The tool also audits for circularity, untested theories that others rely on (weak links), and unfalsifiable theories.

### How proof → reality is bridged (Earth example)
1. **Theory predicts** (the proof side): `SphericalEarth predicts Eratosthenes { value: lean("baseline / r"), fitted: [r] }`
2. **Experiment** (the reality side): `Eratosthenes { result: 7.2 deg ± 1.5 deg }`
3. **Compare and give a verdict:** FlatEarthDistantSun predicts 0°, so it is refuted. SphericalEarth fits with r ≈ 6,400 km, but dof = 0, so this is calibration only.
4. **Blame flows down** `composed_of`: SunIsDistant is supported by radar, so the blame falls on SurfaceIsPlane. `relies_on` edges show what the measurement itself assumes.

### Pipeline mapped onto the files
| Step | In the files | Status |
|---|---|---|
| Intent | `statement` fields; for the tool itself, the reading guide | ✅ |
| Spec | params, observables, edges; for the tool itself, R1–R4 and section 8 | ✅ by example only (no grammar yet) |
| Code | A program that parses `.sci` and computes predictions, dof and verdicts | ❌ not built |
| Proof | `formal: lean { status: unchecked }` (Physlib names are placeholders) | ❌ |
| Reality | experiment `record` and `result` | ✅ |

## Known gaps in the current structs (to fix)

**Top 3 priorities:**
1. A **Quantity node** (r, h, a, b). It enables the shared-parameter check (Eratosthenes needs h ≈ 6,000 km, radar needs h ≈ 1.5e8 km) and joint dof.
2. An **agreement rule on `predicts`** (what tolerance counts as a match) plus machine-readable results. Prose values like the eclipse result can't be compared automatically.
3. **Declared variables and units.** `x_Syene` and `x_Alexandria` are unbound, and deg vs rad and stadia are never converted.

Other gaps:
- A Source/Dataset node (shared raw data).
- A domain-of-validity field on theories.
- Structured uncertainty (statistical vs systematic).
- Soft or probabilistic `supports` edges.
- A `replicates` edge.
- A scope field on `contradicts`.
- Machine-checkable `reduces_to`.
- Provenance and dispute fields on edges.
- A formal grammar.
- Versioning or history (needed for belief revision).

**Issues found in the example file:**
- ThreeSiteShadows: FlatEarthNearSun has a hidden second parameter x₀ (the subsolar point), so its dof is 0, not 1.
- OblateEarth is only calibrated, never tested, unless dof is counted jointly across experiments.
- Radar ranging gives the Earth–Venus distance, not Earth–Sun, so it is missing a `relies_on` Kepler's laws / orbital mechanics edge.

**Design principles for extending the structs:**
- Add a node kind only if it holds a different kind of intrinsic content.
- Add an edge type only if the checker needs a new rule for it. Domain relations ("causes", "catalyzes") are content inside theory statements, not edges.
- Node and theory count grows without limit; edge kinds stay small (about 7 now, maybe 10–12 eventually).

## Related work (read 2026-10)
Existing science-in-Lean projects all use Lean's own structure: nodes are def / structure / theorem, the edges are "uses" (plus "extends"), and assumptions are theorem hypotheses. **None of them has experiment nodes, rival theories, or contradicts.** That is the gap the `.sci` language fills.
- **Physlib** (formerly HepLean/PhysLean; `leanprover-community/physlib`): has a `structure` per system (e.g. HarmonicOscillator with m, k, m_pos, k_pos), uses `extends`, has a `Dimension` units system, and has `InformalLemma` / `InformalDefinition` with `deps` (the closest analogue to `?` holes).
- **LeanChemicalTheories** (Josephson lab, UMBC; arXiv:2210.12150): `thermo_system` structure; conditions such as `isothermal` are Props; laws are defs; derivations are theorems with assumptions passed as hypotheses (Boyle, Langmuir/BET); dimension classes.
- **Descent** (`SauersML/Descent`, Lean 4 genetics): has the rule "Simulations must never be used to fit models", which is the fit-vs-test idea written as policy.
- **SciLean**: numerical computing in Lean. It is not a theory-reasoning structure.
- **JuliaSymbolics / ModelingToolkit / SciML**: strong for computing predictions and fitting parameters (the `predicts` / `fitted` parts). It is not a verifier or a reasoner.
- **ScientistOne** (Google, arXiv:2605.26340): Chain-of-Evidence, where every claim traces to code, data or literature. This is traceability, not truth.
- **Belief revision** (AGM): the `.sci` graph supports contraction mechanically (blame propagation). LLMs revise beliefs poorly (AGM-Bench, ICLR 2026).

## Closest related work (searched and read 2026-10-17): see `RELATED_WORK.md`
Nobody found who combines all of: a model-authored graph + deterministic science-specific rules + RLVR-ready + Lean. ("Not found" is not proof it does not exist.) Four papers were read in full:

| Paper | What it is | What to take | Limit |
|---|---|---|---|
| **ArgGYM** ([2609.38409](https://arxiv.org/abs/2609.38409), METU, Sep 2026) | An ASPIC+ engine (PyArg) computes the one correct state of an argument; the model answers 12 task types (status query, defeat diagnosis, perturbation, interventions). Built as an RLVR environment. | Grade by engine-computed outcomes, not text match; separate exact success from partial credit; fresh verified instances from a seed. | Synthetic abstract theories, no science content; the theory is given; no training run reported. |
| **Open-Endedness Bench** ([2610.02588](https://arxiv.org/abs/2610.02588), ARA Lab, Oct 2026) | Turns an agent's run log into a graph of claims and executed actions; "semantics proposes, actions dispose". Scores evidence, experiment, revision, no reward hacking. Only 16-29% of claimed improvements were real. | A "reliance" claim type (assumption not yet tested); five named gaming attacks with defenses; score = opportunities taken / offered, with abstention. | An LLM extracts the graph (about 652 calls per run), too costly as a training reward by the authors' own words; not tested against optimization. |
| **Douglas, Axioms for physical reasoning** ([2607.06379](https://arxiv.org/abs/2607.06379), Harvard, Jul 2026) | Seiberg-Witten physics in Lean 4: physical assumptions are 8 named hypotheses carried in theorem types, so Lean reports which a result used. | Assumptions as explicit named objects; check hypotheses are not vacuously true ("could the witness be reverse-engineered?"); independent oracle plus adversarial review. | About derivations, not experiments or data; does not check that assumptions are true. |
| **Assurance 2.0** ([2004.10474](https://arxiv.org/abs/2004.10474), Bloomfield and Rushby, 2021) | Safety-case method: tree of claims, steps and evidence; defeaters (undercutting and rebutting); countercases; true / false / unsupported. | Evidence must discriminate a claim from its negation (equal likelihood = zero weight); separate extracting facts from interpreting them; record doubts. | Safety engineering, not science; position paper with no experiments; people judge each evidence step. |

Others noted in `RELATED_WORK.md`: EvoSCM (2609.01526), ACED-Bench (2610.14381), 2511.06701 (Lean false-discovery control), 2604.22041 (Rocq d-separation for experiment design), 2512.06777 (Bayesian Neptune/Mercury), and the full tiered list. Not read yet: the Assurance 2.0 defeaters report (2405.15800), later ArgGYM appendices, and the code repositories.

## Relevant papers (searched 2026-10-11)

**The problem is real:**
- [2604.18805](https://arxiv.org/abs/2604.18805) *AI scientists produce results without reasoning scientifically*: across 25k agent runs, evidence is ignored 68% of the time, and only 26% of runs revise a belief after a refutation. Outcome-based grading can't catch this. This is the strongest motivation.
- [2609.06192](https://arxiv.org/abs/2609.06192) *SciRIGOR*: claims agree with faithful and fake results almost equally (91.8% vs 91.0%), and only 18% of claim chains are fully correct.
- [2604.22080](https://arxiv.org/abs/2604.22080) *Sound Agentic Science Requires Adversarial Experiments*: argues for a falsification-first standard.

**RLVR beyond math and code (the end goal):**
- [2601.17223](https://arxiv.org/abs/2601.17223) ⭐ *Verifiable Process Reward Models*: deterministic rule-based checkers grade each reasoning step (medical risk of bias). Closest to Nilesh's idea.
- [2608.07437](https://arxiv.org/abs/2608.07437) ⭐ *Fisher-R1 / P-Bench*: RL with verifiable statistical rewards for hypothesis testing. Agents run the analysis correctly but still reach wrong conclusions.
- [2503.23829](https://arxiv.org/abs/2503.23829) *Crossing the Reward Bridge* and [2507.17746](https://arxiv.org/abs/2507.17746) *Rubrics as Rewards*: RLVR in science and medicine using LLM judges or rubrics. They are not deterministic, which is the weakness our verifier avoids.
- [2506.14965](https://arxiv.org/abs/2506.14965) *Guru* and [2604.18176](https://arxiv.org/abs/2604.18176) *QuantumQA*: science RLVR datasets that check final answers only.

**Falsification and hypothesis testing:**
- [2502.09858](https://arxiv.org/abs/2502.09858) *Popper*: agents design falsification experiments, with Type-I error control.
- [2606.04751](https://arxiv.org/abs/2606.04751) *FalsifyBench*: models that seek negative tests do best; confirmation bias is the main failure.
- [2502.19414](https://arxiv.org/abs/2502.19414) *REFUTE*: models find counterexamples for fewer than 9% of wrong solutions.
- [2608.22948](https://arxiv.org/abs/2608.22948) *Lit2Test*: each research proposal must state its falsifying outcome in advance.

**Claim and evidence graphs (closest to `.sci`):**
- [2608.04738](https://arxiv.org/abs/2608.04738) *EviGraph*: a typed graph of Hypothesis, Experiment, Finding and Claim nodes, with no rivals, dof or blame.
- [2606.18874](https://arxiv.org/abs/2606.18874) *Xcientist*: tracks "claim drift" from evidence to claim.
- [1305.3506](https://arxiv.org/abs/1305.3506) *Micropublications*: an older format for claims and evidence with support and challenge links; it is not graded.
- Also: the EVI ontology, the EXPO experiment ontology (2006), and the Robot Scientist "Adam" (Science 2009).

**Law discovery without memorization (sources of tasks with known answers):**
- [2605.26087](https://arxiv.org/abs/2605.26087) *DiscoverPhysics*: simulated worlds with altered laws.
- [2607.00276](https://arxiv.org/abs/2607.00276) *Parallel Physical Worlds*: counterfactual physics such as F = mv.
- [2504.10415](https://arxiv.org/abs/2504.10415) *LLM-SRBench*: equation discovery designed to prevent memorization.

**The opening for this project:** no paper deterministically grades scientific reasoning written as a graph, with dof (calibration vs test), sensitivity to hidden assumptions, blame on composed models, and rival theories judged against shared data. Existing work checks only answers, statistics, or claim-to-evidence traceability.

## Related concepts
- **Verification** = "did we build it right" (code ↔ spec). **Validation** = "did we build the right thing" (spec ↔ intent or reality).
- Counterexample loops (CEGIS, CEGAR, symbolic regression, science) all follow "propose → find a counterexample → fix". In symbolic methods the counterexample comes from a solver; in science it comes from reality.

## Suggested next steps (original)
1. Write an explicit formal grammar and a precise rule for each edge.
2. Build the program: parse `.sci` into a graph, then compute dof (including joint dof), units checks, verdicts with blame propagation, and the 3-way sensitivity report.
3. Validate the design with a second example from a different field (e.g. chemistry).

---

## Lean Implementation: Empirica (OFFICIAL; updated 2026-10-17)

**Official repo:** https://github.com/autosciencelabs/empirica (`origin`, branch `main`). The team decided to use this repo, and **the structs in `Empirica/Basic.lean` as they stand are the official ones.** This file was first written before the repo was finalized, so the `.sci` sections above are background and design history (Nilesh's original language), not the official structure. Where the two differ, the Lean code wins. `CLAUDE.md` and `TAXONOMY.md` are not yet committed to the repo (only the `init` commit exists as of this date).

**Files:** `Empirica/Basic.lean` (the core; namespace `Empirica`), re-exported by `Empirica.lean`. Lake project name: `empirica` (library `Empirica`, executable root `Main.lean`). CI: `.github/workflows/lean_action_ci.yml`.

Parth is building a **Lean-native implementation** of Nilesh's ontology ideas, starting from a deliberately minimal core and growing it with 10 domain examples as the hackathon deliverable.

### The official structs (as in `Basic.lean`)
| Item | Fields / meaning |
|---|---|
| `Theory` | `statement : String`, `formal : List Lean.Name := []`, `sources : List String := []`. Identity = structural equality. |
| `Theory.absurd` | The special theory for ⊥. Do not give another theory this exact statement. |
| `Experiment` | `protocol : String`, `observation : String` (must stay uninterpreted), `sources : List String := []`. |
| `Rel.entails premises conclusion` | All premises together imply the conclusion. |
| `Rel.interprets interpretation experiment` | The theory is a reading of the raw record. |
| `Edge` | `rel : Rel`, `why : String := ""`, `formal : List Lean.Name := []`. |
| Edge helpers | `Edge.entails`, `Edge.implies` (one premise), `Edge.nogood` (premises entail absurd), `Edge.contradicts a b` (= `nogood [a, b]`), `Edge.interprets`. |
| `Graph` | `edges : List Edge`. Nodes are whatever the edges mention. |

**Shape of the Earth is NOT part of the deliverable.** It is only Nilesh's example for the `.sci` language (used above to explain the ideas). Do not plan or build a Lean version of it. `Empirica/ShapeOfEarth.lean` is an empty placeholder (`-- To Do`) and not imported anywhere; ignore it.

### Design choices for the Lean version

The Lean version simplifies the full `.sci` spec to stay buildable and demonstrable (corrected 2026-10-17 to match the code):

| `.sci` concept | Lean equivalent |
|---|---|
| `theory` node | `Theory` (statement + optional formal Lean names + sources). `params`, `constants` and `formal: lean{...}` blocks are not fields; `formal` is just a list of names. |
| `experiment` node | `Experiment` (protocol + raw observation, never interpreted inline). No `result ± err`, `inputs`, `systematics` or `status` fields; numbers live inside the prose `observation`. |
| `implies` | `Edge.implies` (= `entails [p] c`) |
| `contradicts` | `Edge.contradicts a b` (= `entails [a, b] absurd`); n-ary version `Edge.nogood` |
| `forbids` | `nogood [theory, outcome-reading]`; no separate edge |
| `composed_of` | Can be written as `entails [parts] model`, but only the "parts imply model" direction exists. Blame flowing down to a part is NOT computed. |
| `predicts` | `entails` plus `interprets`, qualitative only. No `value`, `fitted`, `derivation` or `evidence` attributes. |
| `interprets` (the experiment's `observable` reading, rule R4) | `Rel.interprets` (a theory is a reading of a raw record; several rival readings allowed) |
| `relies_on` (hidden assumptions) | **No equivalent.** A hidden assumption is only an ordinary premise inside an `entails`, with nothing marking it declared, suspected or discovered. `interprets` is NOT `relies_on`. |
| `reduces_to` | None |
| Contradiction | Special `Theory.absurd` node (entailment of `⊥`), keeping inconsistencies local |
| Edge attributes (`limit`, `error_bound`, `status`, `note`) | Only `why : String` and `formal : List Lean.Name` |
| `fitted`, `dof` | Not in the core; to be added as domain examples reveal the need |

**Key omissions vs full `.sci` (intentional for now):**
- No `Quantity` nodes (units, fitted params, dof)
- No blame propagation down `composed_of`
- No `relies_on` edge or three-way sensitivity analysis
- No numeric results or tolerance rule for agreement
- No `reduces_to`
- No formal grammar / parser (Lean values directly)

Which of the 10 taxonomy situations the current core can express is listed at the end of `TAXONOMY.md`.

### Plain-English summary of the ontology

**Two kinds of things:**
- **Theory** — a claim someone makes about the world ("The Earth is round"). Does not carry truth/falsity — that is computed.
- **Experiment** — a record of what was done and literally observed ("Shadow angle was 7.2°"). Never interpreted inline; interpretation always lives in a Theory node.

**Two kinds of connections:**
- **`entails [premises] conclusion`** — "If you believe all these theories, you must also believe this one." Multi-premise so auxiliary hypotheses (Duhem–Quine) are explicit.
- **`interprets theory experiment`** — "This theory is what we think the experiment means." Multiple theories can interpret the same experiment (rival readings).

**Contradiction by construction:**
There is no `contradicts` edge. Instead, `Theory.absurd` (`⊥`) is a special node. `[FlatEarth, ShadowData]` together entailing `⊥` means they can't coexist — but the absurdity is local, not global.

**Computed queries (from just these two edge types):**
- `derive granted` — what follows if you accept a set of theories
- `inconsistent granted` — do those theories jointly entail `⊥`?
- `exclusive a b` — can both theories coexist?
- `supports granted experiment` — does granting these theories let you derive an interpretation of the experiment?
- `refutes granted experiment` — does an interpretation of the experiment make the granted theories explode?
- `justifications t` — what premise sets directly justify theory `t`?

### 10-domain showcase plan

Goal: 10 self-contained domain files, each an `Empirica.Graph` value with real nodes and `#eval` queries demonstrating the ontology's expressiveness. Together they form the hackathon deliverable.

**Domains: see `TAXONOMY.md` (DRAFT v1, 2026-10-17).** An earlier list of guessed domains was removed because it was not researched. The new list is 10 reasoning situations (fit vs test, crucial test, blame, hidden assumption, replication conflict, search effects, exploratory discovery, causal intervention, extrapolation, resolving power), each with one ILLUSTRATIVE episode: Mercury perihelion, Meselson-Stahl, OPERA neutrinos, mesosomes, cold fusion, 750 GeV excess, Penzias-Wilson, Semmelweis, TGN1412, Kaufmann-Bucherer. **Only the 10 categories are decided; the examples are NOT decided.** The episodes only show what each category looks like. Parth plans to broaden the examples later by classifying more episodes into the categories (e.g. only 1 chemistry episode exists for now; more will be added). Do not treat any episode as the final pick. The taxonomy is Claude's synthesis from research and is NOT an agreed standard; Parth accepted the categories as "good enough" as the working list (2026-10-17), but they can still change. Numbers in it must be checked against primary papers before use. Shape of the Earth is out because it is Nilesh's example.
