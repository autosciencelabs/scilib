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

### Domain 2: Crucial test between rivals. Example B: Meselson-Stahl (1958)

| Item | Kind | Verdict |
|---|---|---|
| Publication and reference metadata | node | solid |
| Control and cross-experiment comparison | edge | solid |
| Method reuse link | edge | solid |
| Failed or null attempt | node | tentative |
| Open question | node | tentative |
| Idea origin or analogy | edge | tentative |
| Ordered comparison of quantities | edge | weak |

- solid: seen in most reader runs and the same structure was found elsewhere (expert ontologies, the ten checks, another example).
- tentative: only one of those two holds.
- weak: neither holds.
- Basis: 3 reader runs on 160 sentences of the example's sources.
