# Flow and results

## The flow

```
pick a domain
   -> pick an example (A, B or C)
   -> build the graph
   -> verify the graph against its sources with Jev
   -> graph ready
   -> run the language-gap tools
   -> output: the new nodes and edges the current language needs
```

Current language: nodes Theory and Experiment; edges entails and interprets (`Scilib/Basic.lean`).

## Results

Only solid and tentative items are listed. Solid: seen in 5 or more of the 10 examples (or in most reader runs of the example and also found elsewhere). Tentative: seen in 3-4 examples, or found in an expert ontology or one of the ten checks, or seen in most reader runs. "Seen in" counts the examples where Jev found the same need (score of at least 0.5). All cross-example needs: `parth/NEEDS_ALL.md`.

### 1C. Domain 1: Fit vs test. Example C: Mendeleev's periodic law (1869-86)

| Item | Kind | Seen in | Verdict |
|---|---|---|---|
| Prediction and its later fulfilment | node | 5 of 10 examples | solid |
| Strength of inference | edge | 6 of 10 examples | solid |
| Quantitative law or functional dependence | node | 4 of 10 examples | tentative |
| Biographical and non-scientific content | node | 3 of 10 examples | tentative |
| Methodological norm | node | 3 of 10 examples | tentative |
| Research goal, question or invitation | node | 3 of 10 examples | tentative |
| Explanation of an anomaly | edge | 4 of 10 examples | tentative |
| Class membership and grouping | edge | 2 of 10 examples | tentative |

### 2B. Domain 2: Crucial test between rivals. Example B: Meselson-Stahl (1958)

| Item | Kind | Seen in | Verdict |
|---|---|---|---|
| Publication and reference metadata | node | 10 of 10 examples | solid |
| open question | node | 5 of 10 examples | solid |
| ordered comparison of quantities | edge | 8 of 10 examples | solid |
| Method reuse link | edge | 4 of 10 examples | solid |
| Control or reference sample link | edge | 2 of 10 examples | solid |
| Failed or null attempt | node | 3 of 10 examples | tentative |
| idea origin or analogy | edge | 1 of 10 examples | tentative |

### 3C. Domain 3: Blame among auxiliaries (Duhem-Quine). Example C: OPERA faster-than-light neutrinos (2011-12)

| Item | Kind | Seen in | Verdict |
|---|---|---|---|
| Bibliographic citation record | node | 10 of 10 examples | solid |
| Document metadata and boilerplate | node | 6 of 10 examples | solid |
| Experimental setup and instrument description | node | 4 of 10 examples | tentative |
| Quantitative model and formula | node | 4 of 10 examples | tentative |
| Measurement result as typed record | node | 2 of 10 examples | tentative |
| Method improvement rationale | edge | 2 of 10 examples | tentative |
| Error source attribution with signed effect | edge | 1 of 10 examples | tentative |
| Quantitative prediction from a theory | edge | 1 of 10 examples | tentative |

### 4B. Domain 4: Hidden assumption in the measurement. Example B: Baade's two Cepheid populations (1952)

| Item | Kind | Seen in | Verdict |
|---|---|---|---|
| Equation or functional relation | node | 7 of 10 examples | solid |
| Dated historical event | node | 6 of 10 examples | solid |
| Open question or goal | node | 5 of 10 examples | solid |
| class or kind taxonomy | node | 3 of 10 examples | solid |
| Ordered comparison of quantities | edge | 9 of 10 examples | solid |
| Supersession or revision over time | edge | 7 of 10 examples | solid |
| Graded support or agreement | edge | 6 of 10 examples | solid |
| Causal or explanatory link | edge | 4 of 10 examples | solid |
| theory status or reception | node (readings also said: attribute) | 7 of 10 examples | tentative |
| time-ordered history of estimates | node | 4 of 10 examples | tentative |
| Hypothetical or proposed entity | node | 2 of 10 examples | tentative |
| Motivation, intent or decision | node | 2 of 10 examples | tentative |
| instrument or facility | node | 2 of 10 examples | tentative |
| open problem and its resolution | node | 2 of 10 examples | tentative |
| research program or agent action | node | 2 of 10 examples | tentative |
| Methodological critique of a theory | node | 1 of 10 examples | tentative |
| Spatial distribution or location claim | node | 1 of 10 examples | tentative |
| expectation or prediction before data | edge | 4 of 10 examples | tentative |
| Error and its correction or cancellation | edge | 3 of 10 examples | tentative |
| Object identification or classification | edge | 3 of 10 examples | tentative |
| analogy or method reuse | edge | 3 of 10 examples | tentative |
| Alternatives to decide between | edge | 2 of 10 examples | tentative |
| Assumption with status | edge | 1 of 10 examples | tentative |
| model fit giving a parameter | edge | 1 of 10 examples | tentative |

### 5A. Domain 5: Conflicting results and replication. Example A: LK-99 (2023) (materials)

| Item | Kind | Seen in | Verdict |
|---|---|---|---|
| Publication record | node | 9 of 10 examples | solid |
| Comparison of quantities | edge | 8 of 10 examples | solid |
| Claim attribution and speaker | edge | 7 of 10 examples | solid |
| Open question or deferred analysis | node | 4 of 10 examples | tentative |
| Definition of a term | node | 3 of 10 examples | tentative |
| Figure or data object reference | node | 3 of 10 examples | tentative |
| Computed result node | node | 1 of 10 examples | tentative |
| Significance or motivation statement | node | 1 of 10 examples | tentative |
| Explanation or cause relation | edge | 3 of 10 examples | tentative |
| Method reuse link | edge | 3 of 10 examples | tentative |
| Confound or misattribution | edge | 2 of 10 examples | tentative |
| Replication attempt link | edge | 2 of 10 examples | tentative |

### 6B. Domain 6: Search and selection effects. Example B: 750 GeV diphoton excess (2015-16)

| Item | Kind | Seen in | Verdict |
|---|---|---|---|
| Bibliographic reference | node | 10 of 10 examples | solid |
| Open question or data needed | node | 6 of 10 examples | solid |
| Graded support | edge | 6 of 10 examples | solid |
| Absence-of-signal observation | node | 3 of 10 examples | tentative |
| procedure without result | node | 3 of 10 examples | tentative |
| Derived analysis result | node | 2 of 10 examples | tentative |
| cross-reference pointer | edge (readings also said: attribute) | 3 of 10 examples | tentative |
| Method reuse link | edge | 3 of 10 examples | tentative |
| expected versus observed comparison | edge | 3 of 10 examples | tentative |
| follow-up replication | edge | 3 of 10 examples | tentative |
| rival predictions that differ | edge | 3 of 10 examples | tentative |

### 7B. Domain 7: Exploratory discovery (record vs reading). Example B: Penzias-Wilson, Holmdel 6 m horn antenna (1964-65)

| Item | Kind | Seen in | Verdict |
|---|---|---|---|
| Bibliographic reference entry | node | 10 of 10 examples | solid |
| Planned future measurement | node | 5 of 10 examples | solid |
| Conditional assumption on a conclusion | edge | 7 of 10 examples | solid |
| Necessary condition | edge | 6 of 10 examples | solid |
| Graded or multiple support reasons | edge | 5 of 10 examples | solid |
| Non-scientific narrative event | node | 4 of 10 examples | tentative |
| Prediction preceding observation | edge | 4 of 10 examples | tentative |
| Theory family or lineage | edge | 3 of 10 examples | tentative |
| Challenge to data reliability | edge | 2 of 10 examples | tentative |
| Explanatory failure | edge | 2 of 10 examples | tentative |
| Derived quantity from data reduction | edge | 1 of 10 examples | tentative |

### 8A. Domain 8: Causal intervention and controls. Example A: John Snow and cholera, London 1854

| Item | Kind | Seen in | Verdict |
|---|---|---|---|
| Publication or archive metadata | node | 8 of 10 examples | solid |
| Biographical fact | node | 5 of 10 examples | solid |
| Comparison between groups | edge | 7 of 10 examples | solid |
| Individual case record | node | 2 of 10 examples | tentative |
| Recommendation or policy action | node | 2 of 10 examples | tentative |
| Derived product from data | edge | 1 of 10 examples | tentative |

### 9B. Domain 9: Extrapolation to another system. Example B: Thalidomide across species

| Item | Kind | Seen in | Verdict |
|---|---|---|---|
| Bibliographic reference record | node | 10 of 10 examples | solid |
| Non-entailing support edge | edge | 5 of 10 examples | solid |
| Absence or null outcome | node | 4 of 10 examples | tentative |
| Dated historical event | node | 4 of 10 examples | tentative |
| Protocol-only step | node | 4 of 10 examples | tentative |
| Mechanism step with condition | node | 1 of 10 examples | tentative |
| Alternative candidate explanations | edge | 2 of 10 examples | tentative |
| Causal intervention edge | edge | 2 of 10 examples | tentative |
| Comparison between conditions or entities | edge | 2 of 10 examples | tentative |
| Claim-to-method provenance | edge | 1 of 10 examples | tentative |
| Regulatory or clinical consequence | edge | 1 of 10 examples | tentative |

### 10B. Domain 10: Resolving power: can the data tell the rivals apart? Example B: The ether and the speed of light (1810-1938)

| Item | Kind | Seen in | Verdict |
|---|---|---|---|
| reference or heading fragment | node | 9 of 10 examples | solid |
| ordered comparison | edge | 9 of 10 examples | solid |
| correction notice | node | 2 of 10 examples | tentative |
| variable definition or notation | node | 2 of 10 examples | tentative |
| extension or succession of theory | edge | 4 of 10 examples | tentative |
| class membership | edge | 2 of 10 examples | tentative |
