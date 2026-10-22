```mermaid
graph TD
    subgraph Theories["Theories & Models"]
        BCS["BCS superconductivity"]
        LON["London equations"]
        GIN["Ginzburg–Landau theory"]
        BRAGG["Bragg diffraction law"]
    end

    subgraph DerivedClaims["Derived Claims & Predictions"]
        GAP["Energy gap opens at T < Tc"]
        ZERO["Zero DC resistance"]
        MEISSNER["Meissner expulsion of magnetic flux"]
        FLUX["Flux quantization in loops"]
        PEAKS["Bragg peaks at 2d sinθ = nλ"]
        JOSEPHSON["Josephson phase coherence"]
    end

    subgraph Experiments["Experiments"]
        XRD["X-ray diffraction from crystals"]
        RES["Resistivity drop below Tc"]
        MEI["Meissner effect"]
        FLUXEXP["Flux quantization experiments"]
        JOS["Josephson tunneling"]
    end

    %% Theoretical implications
    BCS -->|implies| GAP
    BCS -->|implies| ZERO
    LON -->|implies| MEISSNER
    GIN -->|implies| FLUX
    BRAGG -->|implies| PEAKS

    %% Derived claims explained by experiments
    PEAKS -->|interprets| XRD
    ZERO -->|interprets| RES
    MEISSNER -->|interprets| MEI
    FLUX -->|interprets| FLUXEXP
    GAP -->|supports| JOS

    %% Contradictions / rival comparisons
    ZERO -.->|contradicts| classicalOhmic["Classical resistive metal model"]
    MEISSNER -.->|contradicts| perfectConductor["Perfect conductor without Meissner effect"]

    classDef theory fill:#ffd1dc,stroke:#333,stroke-width:2px;
    classDef prediction fill:#d1e7dd,stroke:#333,stroke-width:2px;
    classDef experiment fill:#cfe2ff,stroke:#333,stroke-width:2px;
    classDef rival fill:#f3d9c9,stroke:#333,stroke-width:2px;

    class BCS,LON,GIN,BRAGG theory;
    class GAP,ZERO,MEISSNER,FLUX,PEAKS,JOSEPHSON prediction;
    class XRD,RES,MEI,FLUXEXP,JOS experiment;
    class classicalOhmic,perfectConductor rival;
```

# Bragg and superconductivity

This note connects two important strands of modern condensed matter physics:
- Bragg diffraction as a probe of crystal periodicity
- superconductivity as a phase-coherent quantum state with macroscopic order

## Core idea

Crystalline order produces Bragg peaks, while superconductivity produces a macroscopic quantum state characterized by zero resistance, Meissner expulsion, and flux quantization. The same formal tools of periodicity and phase coherence appear in both domains, but in different physical settings.

## Evidence graph

The diagram above encodes a compact evidence structure:

- `Bragg diffraction law` implies `Bragg peaks at 2d sinθ = nλ`
- `BCS superconductivity` implies `energy gap` and `zero DC resistance`
- `London equations` imply `Meissner expulsion`
- `Ginzburg–Landau theory` implies `flux quantization`
- Each theoretical consequence is connected to an experimental reading

## Interpretation

The central scientific pattern is that a model becomes compelling when it predicts multiple independent observations without contradiction. In superconductivity, the same theory explains resistivity collapse, flux expulsion, and phase coherence. In crystallography, Bragg's law explains diffraction peaks from the lattice geometry.

## Key lesson

Strong evidence in physics comes from cross-connection: a model that explains a structural experiment and a quantum-condensed-state experiment is much more persuasive than a mechanism fitted to only one phenomenon.
```

