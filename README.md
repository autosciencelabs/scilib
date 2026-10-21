# scilib

A Lean4-based verifier for semi-formal scientific reasoning.

- This is a Lean4 project built on top of Physlib and Mathlib.
- We model the state of science as a hypergraph of theory and experiment nodes.
- Nodes are primarily informal but can have optional references to Lean terms, poiting to definitions in Physlib.
- Interpretation of an experiment is always a theory node.
- An `entails` hyperedge connects a set of theory nodes to another theory node.
- History of science then becomes the changelog of this hyperlog.
- Globally incompatible/contradictory theories can resemble each other under limits and approximations.
- A special theory node `absurd` models logical contradictions.


See examples:
- 

# Usage

```
lake build
lake exe scilib
```

