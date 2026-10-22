```mermaid
graph TD
    subgraph Theories["Theories & Models"]
        CONT["Continuity equation"]
        BERN["Bernoulli principle"]
        WAVE["Wave optics / Huygens–Fresnel"]
        DIFF["Diffraction as wave interference"]
    end

    subgraph DerivedClaims["Derived Claims & Predictions"]
        PRESS["Pressure falls where fluid speed rises"]
        LIFT["Lift and side force arise from pressure gradients"]
        MIN["Dark fringes occur at path differences of half-wavelengths"]
        PATTERN["Diffraction pattern depends on geometry and wavelength"]
        STREAM["Streamlines bend around obstacles"]
    end

    subgraph Experiments["Experiments"]
        VENT["Venturi tube flow"]
        AIRFOIL["Airfoil / wing in wind tunnel"]
        SLIT["Double-slit and single-slit diffraction"]
        WATER["Water-wave barrier and aperture experiments"]
    end

    %% Theory to prediction
    CONT -->|implies| PRESS
    BERN -->|implies| LIFT
    WAVE -->|implies| MIN
    DIFF -->|implies| PATTERN
    CONT -->|implies| STREAM

    %% Prediction to experiments
    PRESS -->|interprets| VENT
    LIFT -->|interprets| AIRFOIL
    MIN -->|interprets| SLIT
    PATTERN -->|interprets| WATER

    %% Rival / contradiction
    PARTICLE["Particle-only explanation"] -.->|contradicts| PATTERN
    PUREFLOW["No pressure gradient model"] -.->|contradicts| LIFT

    classDef theory fill:#ffd1dc,stroke:#333,stroke-width:2px;
    classDef prediction fill:#d1e7dd,stroke:#333,stroke-width:2px;
    classDef experiment fill:#cfe2ff,stroke:#333,stroke-width:2px;
    classDef rival fill:#f3d9c9,stroke:#333,stroke-width:2px;

    class CONT,BERN,WAVE,DIFF theory;
    class PRESS,LIFT,MIN,PATTERN,STREAM prediction;
    class VENT,AIRFOIL,SLIT,WATER experiment;
    class PARTICLE,PUREFLOW rival;
```

# Diffraction and Bernoulli

This note combines two classic explanatory systems:
- Bernoulli’s principle for fluid flow and pressure gradients
- diffraction as a wave phenomenon that depends on path differences and geometry

## Core idea

The Bernoulli principle says that in steady incompressible flow, pressure decreases where speed increases. Diffraction, by contrast, follows from the wave nature of light or water, where phase differences create constructive and destructive interference.

## Evidence graph

The diagram above organizes the structure of the argument:

- `Continuity equation` and `Bernoulli principle` imply a pressure drop where the flow speeds up
- `Wave optics` and `diffraction` imply alternating bright and dark regions from phase differences
- These claims are then matched to experiments: venturi flow, airfoil lift, and slit/barrier diffraction

## Why the two topics matter together

Although Bernoulli and diffraction are not the same theory, they are both examples of how physics turns observations into structural claims. In each case, the model does not just describe the experiment; it predicts new effects and constrains what is and is not possible.

## Scientific lesson

When a model is successful, it is not enough that it fits one observation. It must also explain several independent experiments and remain stable under contrast with rival explanations.
```
