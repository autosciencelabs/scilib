# Empirica: closest related work (research of 2026-10-17)

Question: who has built, or come close to, a **deterministic checker that grades scientific reasoning written as a structured graph**, usable as an RL reward?

Short answer: **nobody has built all of it.** Pieces exist in four separate places. The two closest neighbours each miss one key property.

## Scope and honesty about this search
- Tools used: alphaXiv, Firecrawl paper search, Exa, web fetch. The Elicit connector was blocked (no API plan).
- I read full-text summaries for about 10 papers and abstracts for the rest. I did not read any paper line by line.
- "Nobody has built it" means I did not find it. It is not proof that it does not exist.
- All arXiv IDs below are as returned by the search tools; open each before citing.

## What Empirica is (the 4 properties we are looking for)
| Property | Meaning |
|---|---|
| A. Model-authored graph | The AI writes an explicit graph of theories, experiments and links |
| B. Deterministic checks | Same input, same score; no LLM judge inside |
| C. Science-specific rules | Fit vs test, blame among assumptions, rival elimination, assumption sensitivity |
| D. RL-reward ready | Cheap and stable enough to use as a training signal (RLVR) |
| (E.) Formal substrate | Lean, so rules are machine-checked |

## Tier 1: closest (each has 2-3 of the properties)

| Work | What it does | Has | Misses |
|---|---|---|---|
| **ArgGYM** (2609.38409, METU, Sep 2026) | An ASPIC+ argumentation engine computes the formal state of a defeasible argument. 12 tasks (formalization, defeat diagnosis, **theory revision**, preference reasoning, intervention). Procedural generators plus verifiers; built as an **RLVR environment**. | A (partly), B, D | C: generic arguments, **no experiments, data, dof or science-specific rules**. Not Lean. |
| **Open-Endedness Bench, OEB** (2610.02588, Oct 2026) | Compiles an agent's run log into an **epistemic event graph** (propositions + executed acts, typed edges). Scores evidence, experiment, revision, no-reward-hacking. **No answer key needed.** Finds only 16-29% of claimed improvements are real. | C (partly), the same goal as ours | B and D: the graph is **extracted by an LLM** (about 652 judge calls per run); the authors say it is "more suitable for offline analysis than as a frequent training reward". The model does not author the graph. |
| **AI scientists produce results without reasoning scientifically** (2604.18805) | Labels each trace step (hypothesis / evidence / test / justify / update / commit) and defines good and bad patterns. | C (as diagnostics) | B and D: annotation partly manual/LLM; diagnostic only, not a reward. |

## Tier 2: strong on one property

| Work | Strong on | Why it matters to us |
|---|---|---|
| **Assurance 2.0** (Bloomfield and Rushby; 2405.15800) | A, C | Claims, evidence, assumptions and **defeaters** (doubts attached to a node). Three statuses: true / false / unsupported. Confirmation measures: evidence must discriminate a claim from its negation. Built for safety cases, not science. Closest structural analogue to `entails` plus assumptions. |
| **Axioms for physical reasoning** (Douglas, Harvard; 2607.06379) | E, C | Lean 4. Physical assumptions are **named postulates carried as hypotheses in theorem types**, so the prover reports exactly which assumptions a result used. Aimed at checking AI-generated physics. Covers derivations, not experiments. |
| **EvoSCM** (2609.01526) | A, C | Hypotheses are structural causal models (explicit graphs). A population of rivals; revision operators; a deduction check that a revision does not contradict **earlier** evidence. LLM-driven, scored against a simulator, not a Lean checker. |
| **ACED-Bench** (2610.14381) | B | Hidden probabilistic graphical model gives exact oracle answers; tests whether agents choose the right experiments and when to commit. Neuro-symbolic. Causal-structure tasks only. |
| **Structural Enforcement of Statistical Rigor** (2511.06701) | B, E | Lean 4 proof of false-discovery-rate control; a "Research monad" that cannot test a hypothesis without spending the error budget. Directly covers our category #6 (search effects). |
| **Causality and Semantic Separation** (2604.22041) | B, E | Rocq-mechanized proof that d-separation correctly decides whether an experiment design controls for confounders. Covers our category #8. |
| **Evidence and Elimination** (2512.06777) | C | Bayesian falsification as model elimination; works the **Neptune and Mercury** cases (our categories #1 and #3). Quantitative, no graph. |
| **Neuro-symbolic PRM** (2608.26329) | B | Deterministic checks for syntax, arithmetic and **units** (Pint), then a learned model for semantic correctness. Shows the split "deterministic part first, learned part second". It does not check scientific method. |

## Tier 3: same area, but LLM-judged or narrow
- **PhysClosureBench** (2610.21767): "Research Closure" levels RC0-RC4 for whether evidence requirements are met. Rubric-based; Claude-Opus-5 reaches RC4 in 32.7% of attempts.
- **FirstResearch** (2607.05682) and **Lit2Test** (2608.22948): force each proposal to state its falsifier in advance. Scored by LLM judges.
- **Hypothesis Evolution Protocol** (2607.09195), **ScientistOne** (2605.26340), **ABE-Ralph** (2608.26753): audit trails and claim-to-evidence tracing. Traceability, not truth.
- **TRACE** (2605.29656): Toulmin-structure grading of reasoning. **Epistemic Regret Minimization** (2602.11675): a critique of the causal structure of a trace used as reward, but critiques are model-generated. **TRACES** (2608.11415): can models spot retracted or fraudulent papers.
- **DERELAB** (2608.30413), **KC-Bench** (2609.03588): belief revision and confirmation bias under conflicting evidence.
- **Evidence-Informed LLM Beliefs** (2606.29182): belief updating over past discoveries; rewards are LLM-elicited.
- **Verifier Errors in RLVR** (2609.35677): imperfect verifiers get reward-hacked. A warning for us: our rules must be hard to game.

## Older foundations
EXPO and OBI (ontologies of experiments, for annotating records); Robot Scientist "Adam" (2009); Micropublications and the EVI ontology (claims plus evidence links, not graded); AGM belief revision and its LLM benchmarks.

## Where Empirica sits

```
                      science-specific rules (C)
                              ▲
        OEB, Corral  ●        │        ● Empirica (target)
        (LLM-extracted,       │        (model-authored graph, deterministic,
         diagnostic)          │         Lean, reward-ready)
                              │
   Assurance 2.0 ●            │
   (engineering, not science) │
  ───────────────────────────┼──────────────────────────► deterministic + RL-ready (B, D)
                              │
              EvoSCM ●        │        ● ArgGYM
              (simulator)     │        (deterministic, RLVR, but generic arguments)
```

## What this suggests for our design (ideas to borrow, not decisions)
1. **Hidden assumptions as explicit hypotheses** (Douglas). Carry each assumption in the type of the claim that depends on it, so Lean can report which assumptions a verdict used. This is a concrete way to fill the missing `relies_on` edge and the three-way sensitivity check.
2. **Three statuses plus defeaters** (Assurance 2.0). `true / false / unsupported`, and a doubt node attached to a claim. Fits our `refutes` and `justifications`.
3. **Procedural generators plus engine-verified scoring** (ArgGYM). The route from a handful of hand-written episodes to a training-scale pool: generate fresh instances that have known answers.
4. **"Prose can state a claim; only an executed result can support it"** (OEB). A clean rule for what counts as evidence in the graph.
5. **Deterministic first, learned second** (NS-PRM). Our verifier is the deterministic layer; anything judged by a model stays outside it.
6. **Guard against reward hacking** (2609.35677). Plan adversarial tests: a model that learns to emit graphs that score well but do not reflect real reasoning.

## Positioning in one paragraph
ArgGYM shows that engine-verified, RLVR-ready defeasible reasoning is feasible, but for generic arguments. OEB shows that epistemic process in scientific work can be scored without an answer key, but through an expensive LLM-extracted graph. Empirica's open ground is the combination: a graph the model writes itself, checked by fixed rules specific to empirical science (fit vs test, blame, assumption sensitivity, rival elimination), in Lean, cheap enough to be a reward.

## Deep read of the two closest papers (2026-10-17)
I read both in full (ArgGYM main text plus appendices A-B and the start of C; OEB all 18 pages from the PDF). Both are arXiv preprints from Sep/Oct 2026, not peer reviewed.

### ArgGYM (2609.38409): what it really is
- **Engine:** PyArg 2.0.2 computes ASPIC+ argumentation states (attacks: undermine, rebut, undercut). Grounded semantics gives one unique answer, so every instance has one deterministic correct state. The model never sees the engine.
- **Instances are synthetic and abstract.** Theories use random symbols (premise `ko9`, rule `vo8: ko9 => ls2`). No science content. The authors list this as a limitation.
- **12 tasks over one substrate:** formalize text into a theory; recover a support chain; diagnose why a claim fails (which defeater, which attack type); query claim statuses; query under other semantics; **perturbation** (which claims change status after an update); and 6 constructive tasks (add preferences, counter-argue, attack, defend...).
- **Scoring ideas worth copying:**
  - *Behavioural equivalence, not text match:* a submitted formalization counts if it induces the same engine-computed statuses over every literal of the reference theory.
  - *Execute the answer:* constructive answers are run through the engine and checked for the requested outcome plus consistency; any valid intervention passes.
  - *Two numbers per task:* complete-task success (exact) and a task-native partial score. They are never averaged across tasks.
  - *Efficiency credit:* `0.5 + 0.5 * min(1, m/n)` against a verified minimum; more than 2m directives = failure.
  - *Anti-shortcut gates:* generators reject instances that lack the intended phenomenon and balance labels so majority guessing fails.
  - *Procedural generation:* a function of (task, level, ordering, seed) gives fresh verified instances; the frozen benchmark is kept separate from training instances. A re-execution audit of all 1,440 frozen instances found zero mismatches (it is not an independent second implementation of ASPIC+).
- **Finding:** models are good locally but poor at composing a whole state (for example 88.7 native vs 35.8% complete on status_query). Best model 82.4% complete.
- **Built for RLVR** (generators plus verifiers) but **no training experiment is reported.**
- **Gap versus us:** the theory is *given*; the model only answers questions about it. No experiments, numbers, dof, hidden assumptions or any science-specific check.

### Open-Endedness Bench (2610.02588): what it really is
- **Input:** an agent's execution log (action, observation, reasoning per step). It never reads the task score or an answer key.
- **Graph:** two planes. *Act nodes:* check, probe, commit, revise. *Proposition nodes:* belief, conjecture, prediction, question, **reliance (an assumption built on without testing)**, retract. Edges include supports, contradicts, expects, explains, reads, responds-to.
- **Pipeline:** L0 code converts logs; L1 an LLM extracts cards, each with an exact quote that code checks is a literal substring; L2 closed-question "juries" (3 votes, majority) link cards; **L3 code assembles the graph and a measurement layer scores it with no LLM calls.** So it is partly deterministic. The LLM is confined to extraction and closed questions.
- **Core principle:** "semantics proposes, actions dispose". Only a result from an executed action can support or contradict a claim; prose alone earns nothing.
- **Scores:** every rate is *opportunities taken / opportunities offered.* A measure with fewer than 5 opportunities abstains (never scores zero). Four axes: Evidence (includes "reliance tested"), Experiment, Revision, No reward hacking (`1/(1+k)`). Axes are never combined into one number.
- **Gaming defenses (appendix A):** five named attacks and their defenses (cheap declarations, parroting observations, self-citation, ritual acknowledgement, refusing falsifiable predictions).
- **Findings:** only 16-29% of claimed improvements were real; 60% of speedrun follow-ups built on a non-real win; it flagged 10 of 11 runs that PostTrainBench auditors judged to be cheating; rescoring changed scores by a median of 0.04.
- **Limits stated by the authors:** about 652 judge calls per run ("offline evaluation, not a training reward"); under-measures agents that reason only through numbers or off the record; not tested against an agent optimizing against it.
- **Gap versus us:** it checks a graph *extracted from what an agent did*. It has no rival theories, no fit-vs-test, no blame, no sensitivity check.

### What this changes in our picture
1. **Two different jobs.** ArgGYM verifies answers about a *given* theory. OEB verifies a *story against an execution record.* Empirica asks the model to *write the scientific graph from a documented episode* and verifies it. That is a third job, and I found nobody doing it.
2. **Take the evidence from the task, not from the model.** Both papers avoid trusting the model's own account of the data (ArgGYM supplies the theory; OEB reads the executed record). For Empirica the experiment nodes (records and numbers) should be supplied by the task, and the model supplies theories and links. Otherwise a model can invent convenient evidence. This fits rule R4 (record vs reading).
3. **OEB already has our missing edge in spirit:** a proposition type "reliance" (an assumption not yet tested) and a score for "reliance tested". This supports adding an explicit hidden-assumption marker to the Lean core.
4. **Grade by computed verdicts, not structure.** ArgGYM's behavioural equivalence suggests scoring a model's graph by what `derive`, `inconsistent`, `supports` and `refutes` return on it, compared with the reference graph, instead of matching nodes and edges.
5. **A natural task suite** mirrors ArgGYM: given an episode, (a) status query (what is supported or refuted), (b) blame diagnosis, (c) perturbation (what flips if an assumption or datum is dropped), (d) repair/intervention. This is an idea to consider, not a decision.
6. **Scoring conventions to borrow:** exact-success plus partial score kept separate; opportunities-taken / opportunities-offered with abstention; a verified minimum for edit-style tasks.
7. **Risks both papers flag that apply to us:** abstract, synthetic data does not prove transfer to real science (ArgGYM); a verifier is not safe against a model trained to optimize it (OEB); local correctness does not compose into global correctness (ArgGYM).

### Douglas 2607.06379: what it really is
- Single-author working paper (Harvard, July 2026), companion to the Lean repo `mrdouglasny/seiberg-witten`. Written with heavy use of Claude, with Gemini and Codex for cross-checks.
- **Problem:** much of physics is not proved, and AI-generated derivations tend to fail by a *hallucinated assumption*, not a wrong algebra step.
- **Method:** state the physics as 8 named hypotheses (H0-H7) written as Lean predicates or structures that a theorem carries **in its type**. They are deliberately not global axioms. The 5 genus-one mathematical axioms name only classical mathematics (no physics words). A "dictionary" file maps each physics concept to a math object, so physics never enters silently.
- **Auditing:** `#print axioms` lists the logical and mathematical axioms a result used. Physical hypotheses are tracked by appearing in the theorem's signature.
- **Result:** SU(2) existence and uniqueness (up to a duality frame) proved; the count of exactly 3 singular points derived rather than assumed; a worked check on Argyres-Douglas points.
- **Checking the assumptions:** an independent numerical oracle (278 checks); adversarial cross-model review; and the "physicist's triangle" (three independent routes agreeing).
- **Lessons that matter to us:** the first drafts of the hypotheses were *vacuously true*, so they had to be hardened. The heuristic: for every existential inside a hypothesis, ask what stops the witness from being reverse-engineered from the thing being constrained. Quote: "Sampling bounds falsity; statement-level review bounds fitness for purpose."
- **Limits:** about derivations, not experiments or data. It does not check whether the assumptions are *true*; that comes from outside agreement.

### Assurance 2.0 manifesto (Bloomfield and Rushby, 2004.10474v3, Jan 2021): what it really is
- A position paper, with no empirical evaluation. The authors say they used the ideas in training groups and projects.
- **Structure:** a tree of claims, argument steps and evidence. Five building blocks (evidence incorporation, calculation, decomposition, substitution, concretion). Steps should be *deductive* where possible. Where they are not, add an explicit "nugatory side claim" that stands for the missing piece.
- **Evidence weight:** evidence must *discriminate* a claim from its negation. They use confirmation measures (Good's log P(e|c)/P(e|not c); Kemeny-Oppenheim). If the evidence is just as likely under the counterclaim, its weight is about zero.
- **Two kinds of defeat:** *undercutting* (evidence inadequate or irrelevant) and *rebutting* (evidence contradicts the claim). Defeaters are recorded. A case is "indefeasible" only when all known doubts were examined.
- **Countercases:** an explicit case for the negation, as a source of defeaters.
- **Facts vs inference:** their Figure 6 separates *extracting the facts from a report* from *interpreting them with a model*. The example is "passed N tests" (weak) vs "N failure-free demands in succession and no other failures" (the precise record).
- **Confidence:** kept separate from soundness. Product of confidences for deductive steps; sum of doubts otherwise. The authors note that 12 published probabilistic schemes all give implausible results on perturbation, so they keep it simple and qualitative.
- **Limits:** safety engineering, not science; judgment by people at every evidence step; no automation in this paper.

### What the last two add to the picture
1. **A concrete form for the hidden-assumption edge** (Douglas): each assumption is a named object the dependent claim must carry, so the checker can list exactly which assumptions a verdict used. Also a built-in test for assumptions that say nothing (vacuity).
2. **Resolving power is already a formal idea** (Assurance 2.0): evidence that is equally likely under both rivals has zero weight. That is our category #10 in one line, and it also supports #2.
3. **Record vs reading is already a design rule** (Assurance 2.0 Figure 6), the same as Nilesh's R4.
4. **Two kinds of defeat map onto our graph:** undercutting (the evidence does not support, or the instrument or assumption is bad) and rebutting (a contradicting result). Today the Lean core can only express the rebutting kind, through `absurd`.
5. **Cautions:** both rely on external human judgment for the truth of the assumptions or the evidence; neither automates it.

## Still not read
ArgGYM appendix C-D tables beyond the first example; the Assurance 2.0 defeaters report (2405.15800) and its confidence report (2205.04522) beyond abstracts; PyArg and the OEB repository code; the Douglas Lean repository itself.
