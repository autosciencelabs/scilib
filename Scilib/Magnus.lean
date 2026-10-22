import Scilib.Basic

/-!
# The Magnus effect

A spinning body moving through a fluid is pushed sideways, perpendicular to both
its direction of travel and its spin axis.  One phenomenon, but explaining it
connects several separate laws:

* the **no-slip condition** (the spinning surface drags fluid along),
* **Bernoulli's principle** (faster flow, lower pressure),
* the **Kutta–Joukowski theorem** (lift = ρ U Γ),
* **Newton's second and third laws** (turning the airstream pushes the body back),
* **rotational kinematics** (surface speed is ωR).

The graph checks that three independent routes (pressure, circulation, momentum)
all reach the same force, and that the force explains data from tennis balls,
musket balls, Magnus's cylinder, pressure taps, a wind tunnel and a rotor ship.
-/

namespace Scilib.Magnus

/-! ## Raw experiments -/

def tennisBallExperiment : Experiment :=
  { protocol := "Watch tennis balls struck with deliberate topspin, backspin and sidespin travel through still air."
    observation := "Topspin balls dip sooner than unspun balls, backspin balls stay aloft longer, and sidespin balls drift sideways."
    sources := ["I. Newton, Philosophical Transactions of the Royal Society, 7, 1672"] }

def musketBallExperiment : Experiment :=
  { protocol := "Fire musket balls through deliberately imperfect barrels and mark where they land relative to the line of aim."
    observation := "Balls land well to one side of the aim line, and the side depends on how the barrel was set."
    sources := ["B. Robins, New Principles of Gunnery, 1742"] }

def magnusCylinderExperiment : Experiment :=
  { protocol := "Mount a brass cylinder on a pivoted frame in a steady air blast with its axis perpendicular to the blast, spin it in either sense, and watch the frame."
    observation := "The frame swings sideways, perpendicular to both the blast and the cylinder's axis; reversing the spin reverses the swing."
    sources := ["G. Magnus, Annalen der Physik und Chemie, 88, 1853"] }

def surfacePressureExperiment : Experiment :=
  { protocol := "Fit a cylinder with pressure taps around its surface, spin it in a wind tunnel, and record the pressure at each tap."
    observation := "Taps on the side moving with the oncoming air read lower pressure than taps on the side moving against it."
    sources := ["A. Thom, Aeronautical Research Committee Reports and Memoranda, 1925-1926"] }

def windTunnelLiftExperiment : Experiment :=
  { protocol := "Measure the sideways force on a cylinder with end plates in a wind tunnel while varying the ratio of its surface speed to the wind speed."
    observation := "The force coefficient rises with the speed ratio, then levels off at larger ratios."
    sources := ["L. Prandtl, Die Naturwissenschaften, 13, 1925"] }

def flettnerRotorShipExperiment : Experiment :=
  { protocol := "Fit a ship with tall vertical cylinders spun by motors, sail across a steady crosswind, and record the ship's motion with the spin on, off and reversed."
    observation := "With the cylinders spinning the ship is driven across the wind; with them stopped it is not, and reversing the spin reverses the thrust."
    sources := ["A. Flettner, rotor ship Buckau trials, 1924-1926"] }

/-! ## Readings: interpretations of the raw records -/

def spinDeflectsBallReading : Theory :=
  { statement := "A spinning ball's flight path departs from the path of an unspun ball, and the direction of departure depends on the sense of spin." }

def sidewaysForceReading : Theory :=
  { statement := "A cylinder spinning in a cross-flow is pushed perpendicular to both the flow and its axis, and the push reverses when the spin reverses." }

def surfacePressureReading : Theory :=
  { statement := "Pressure on a spinning cylinder is lower on the side moving with the oncoming stream and higher on the opposite side." }

def liftRisesWithSpinReading : Theory :=
  { statement := "The force on a spinning cylinder grows as its surface speed grows relative to the stream speed." }

def liftFlattensBelowIdealReading : Theory :=
  { statement := "At larger spin ratios the measured lift coefficient levels off and stays below the ideal-flow value 2πS, where S = ωR/U." }

def rotorShipThrustReading : Theory :=
  { statement := "Spinning vertical cylinders on a ship produce thrust across the wind, and reversing the spin reverses the thrust." }

/-! ## Laws and auxiliary assumptions -/

def noSlipCondition : Theory :=
  { statement := "No-slip condition: fluid in contact with a solid surface moves with that surface." }

def attachedBoundaryLayer : Theory :=
  { statement := "The boundary layer stays attached long enough for the surface's motion to be carried into the surrounding flow." }

def bernoulliPrinciple : Theory :=
  { statement := "In steady, inviscid, incompressible flow along a streamline p + ½ρv² is constant, so faster flow means lower pressure." }

def outerFlowIdeal : Theory :=
  { statement := "Outside the thin boundary layer the flow is approximately steady, inviscid and incompressible." }

def kuttaJoukowski : Theory :=
  { statement := "For steady ideal flow past a long cylinder, the force per unit length is L′ = ρUΓ, perpendicular to the stream velocity U." }

def surfaceSpeedIsOmegaR : Theory :=
  { statement := "A point on the surface of a cylinder of radius R spinning at angular speed ω moves at speed ωR." }

def newtonSecondLaw : Theory :=
  { statement := "The net force on a body equals its rate of change of momentum." }

def newtonThirdLaw : Theory :=
  { statement := "When a body exerts a force on a fluid, the fluid exerts an equal and opposite force on the body." }

def ballForceBalance : Theory :=
  { statement := "Over a short flight the ball's mass is constant and its acceleration is set by gravity, drag and the spin-induced force." }

def verticalRotorsInCrosswind : Theory :=
  { statement := "The ship's cylinders spin about vertical axes in a steady horizontal wind." }

def separationLimitsLift : Theory :=
  { statement := "Boundary-layer separation and finite-length end effects reduce the real force below the ideal-flow value at high spin ratio." }

/-! ## Derived claims -/

def circulationAroundSpinner : Theory :=
  { statement := "A body spinning in a stream drags fluid with it and sets up circulation Γ around itself." }

def speedAsymmetry : Theory :=
  { statement := "Fluid speed past the body is higher on the side where its surface moves with the stream and lower on the other side." }

def lowerPressureOnFastSide : Theory :=
  { statement := "Pressure is lower on the faster-flow side of a spinning body and higher on the slower-flow side." }

def pressureForceTowardFastSide : Theory :=
  { statement := "The net pressure force on a spinning body points toward the faster-flow side." }

def streamDeflection : Theory :=
  { statement := "A body carrying circulation turns the oncoming stream toward the side where its surface moves against the stream." }

def rigidRotationCirculation : Theory :=
  { statement := "A cylinder of radius R spinning at ω carries circulation Γ = 2πωR²." }

def idealMagnusLift : Theory :=
  { statement := "In the ideal limit the force per unit length on a spinning cylinder is L′ = 2πρUωR², i.e. lift coefficient C_L = 2πS with spin ratio S = ωR/U." }

def magnusForce : Theory :=
  { statement := "A body spinning in a stream feels a force perpendicular to both the stream and its spin axis, pointing toward the side where its surface moves with the stream." }

def curvedFlightPrediction : Theory :=
  { statement := "A spinning ball in flight follows a curved path: topspin makes it dip sooner, backspin keeps it aloft longer and sidespin makes it drift sideways." }

def flettnerThrust : Theory :=
  { statement := "Tall vertical cylinders spun on a ship's deck push the ship across the wind, and reversing the spin reverses the push." }

def magnusEffectModel : Theory :=
  { statement := "Magnus effect model: spin sets up circulation, giving a sideways force perpendicular to stream and axis that equals the ideal-flow value in the low-spin limit and falls below it at high spin." }

/-! ## Rivals and the comparison criterion -/

def spinIrrelevantModel : Theory :=
  { statement := "Spin has no effect on the path of a ball in flight." }

def noCirculationFlow : Theory :=
  { statement := "A spinning cylinder leaves the outer flow unchanged, so the flow has no circulation and no net sideways force acts on it (d'Alembert's paradox)." }

def idealLiftIsExact : Theory :=
  { statement := "The ideal-flow lift L′ = 2πρUωR² holds exactly for real spinning cylinders at every spin ratio." }

def explanatoryCriterion : Theory :=
  { statement := "Between these alternatives, prefer the model that accounts for the independent observations without being contradicted by any of them." }

def magnusBeatsRivals : Theory :=
  { statement := "The Magnus circulation model is better supported than the spin-irrelevant and no-circulation rivals." }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- experiments to readings
        Edge.interprets spinDeflectsBallReading tennisBallExperiment
          "Topspin, backspin and sidespin paths are read as spin-dependent curved flight."
      , Edge.interprets spinDeflectsBallReading musketBallExperiment
          "Lateral miss distances are read as a spin-dependent deflection."
      , Edge.interprets sidewaysForceReading magnusCylinderExperiment
          "The swing of the frame is read as a sideways force on the spinning cylinder."
      , Edge.interprets surfacePressureReading surfacePressureExperiment
          "The tap readings are read as a pressure asymmetry around the cylinder."
      , Edge.interprets liftRisesWithSpinReading windTunnelLiftExperiment
          "The rising force coefficient is read as growth of lift with spin ratio."
      , Edge.interprets liftFlattensBelowIdealReading windTunnelLiftExperiment
          "The levelling-off is read as saturation below the ideal-flow value."
      , Edge.interprets rotorShipThrustReading flettnerRotorShipExperiment
          "The ship's motion is read as thrust produced by the spinning cylinders."
        -- shared cause: spin sets up circulation
      , Edge.entails [noSlipCondition, attachedBoundaryLayer] circulationAroundSpinner
          "The no-slip surface drags fluid around, so spin becomes circulation in the outer flow."
        -- route 1: pressure (Bernoulli)
      , Edge.implies circulationAroundSpinner speedAsymmetry
          "Adding circulation to the stream speeds the flow on one side and slows it on the other."
      , Edge.entails [speedAsymmetry, bernoulliPrinciple, outerFlowIdeal] lowerPressureOnFastSide
          "Bernoulli turns the speed difference into a pressure difference."
      , Edge.implies lowerPressureOnFastSide pressureForceTowardFastSide
          "Integrating the pressure over the surface gives a net force toward the low-pressure side."
      , Edge.implies pressureForceTowardFastSide magnusForce
          "The pressure force is the Magnus force."
        -- route 2: circulation (Kutta–Joukowski)
      , Edge.entails [kuttaJoukowski, circulationAroundSpinner, outerFlowIdeal] magnusForce
          "L′ = ρUΓ is perpendicular to the stream, with its sign set by the circulation."
        -- route 3: momentum (Newton)
      , Edge.implies circulationAroundSpinner streamDeflection
          "Circulation bends the streamlines, turning the stream to one side."
      , Edge.entails [streamDeflection, newtonSecondLaw, newtonThirdLaw] magnusForce
          "Turning the stream changes its momentum, so the body is pushed the opposite way."
        -- magnitude: kinematics plus Kutta–Joukowski
      , Edge.entails [circulationAroundSpinner, surfaceSpeedIsOmegaR] rigidRotationCirculation
          "Surface speed ωR around the circumference 2πR gives Γ = 2πωR²."
      , Edge.entails [kuttaJoukowski, rigidRotationCirculation, outerFlowIdeal] idealMagnusLift
          "Substituting Γ = 2πωR² into L′ = ρUΓ gives L′ = 2πρUωR²."
        -- predictions: theory to readings
      , Edge.implies idealMagnusLift liftRisesWithSpinReading
          "The ideal law predicts lift growing linearly with spin ratio."
      , Edge.implies separationLimitsLift liftFlattensBelowIdealReading
          "Separation and end effects predict lift saturating below the ideal value."
      , Edge.implies lowerPressureOnFastSide surfacePressureReading
          "The pressure asymmetry is exactly what the pressure taps measure."
      , Edge.implies magnusForce sidewaysForceReading
          "A force toward the side moving with the stream reverses when the spin reverses."
        -- applications
      , Edge.entails [magnusForce, newtonSecondLaw, ballForceBalance] curvedFlightPrediction
          "Adding the Magnus force to the force balance bends the ball's trajectory."
      , Edge.implies curvedFlightPrediction spinDeflectsBallReading
          "Curved flight is what the tennis and musket observations record."
      , Edge.entails [magnusForce, verticalRotorsInCrosswind] flettnerThrust
          "A force perpendicular to the wind and the vertical axis is horizontal thrust across the wind."
      , Edge.implies flettnerThrust rotorShipThrustReading
          "The predicted thrust is what the rotor ship shows."
        -- the model and the verdict
      , Edge.entails
          [circulationAroundSpinner, magnusForce, idealMagnusLift, separationLimitsLift]
          magnusEffectModel
          "Circulation, the sideways force, the ideal-flow limit and its high-spin correction together form the model."
      , Edge.entails
          [magnusEffectModel, spinDeflectsBallReading, sidewaysForceReading,
            surfacePressureReading, rotorShipThrustReading, liftRisesWithSpinReading,
            explanatoryCriterion]
          magnusBeatsRivals
          "The model accounts for independent evidence from balls, cylinders, pressure taps, a wind tunnel and a ship."
        -- contradictions
      , Edge.contradicts spinIrrelevantModel spinDeflectsBallReading
          "Spin cannot be irrelevant if spinning balls leave the unspun path."
      , Edge.contradicts spinIrrelevantModel magnusEffectModel
          "The model says spin produces a force; the rival says it does not."
      , Edge.contradicts noCirculationFlow sidewaysForceReading
          "With no circulation there is no sideways force, yet one is measured."
      , Edge.contradicts noCirculationFlow circulationAroundSpinner
          "Zero circulation and non-zero circulation cannot both hold."
      , Edge.contradicts idealLiftIsExact liftFlattensBelowIdealReading
          "An exact ideal law cannot also level off below its own value."
      ] }

/-! ## Evidence bundles (the `granted` lists) -/

def pressureRoute : List Theory :=
  [noSlipCondition, attachedBoundaryLayer, bernoulliPrinciple, outerFlowIdeal]

def circulationRoute : List Theory :=
  [noSlipCondition, attachedBoundaryLayer, kuttaJoukowski, outerFlowIdeal]

def momentumRoute : List Theory :=
  [noSlipCondition, attachedBoundaryLayer, newtonSecondLaw, newtonThirdLaw]

def liftFormulaEvidence : List Theory :=
  [noSlipCondition, attachedBoundaryLayer, surfaceSpeedIsOmegaR, kuttaJoukowski, outerFlowIdeal]

def allPhysics : List Theory :=
  [noSlipCondition, attachedBoundaryLayer, bernoulliPrinciple, outerFlowIdeal,
    kuttaJoukowski, surfaceSpeedIsOmegaR, newtonSecondLaw, newtonThirdLaw,
    ballForceBalance, verticalRotorsInCrosswind, separationLimitsLift]

def combinedEvidence : List Theory :=
  allPhysics ++
    [spinDeflectsBallReading, sidewaysForceReading, surfacePressureReading,
      rotorShipThrustReading, liftRisesWithSpinReading, explanatoryCriterion]

/-! ## Checks: three independent routes reach the same force -/

#guard (evidenceGraph.derive pressureRoute).contains magnusForce
#guard (evidenceGraph.derive circulationRoute).contains magnusForce
#guard (evidenceGraph.derive momentumRoute).contains magnusForce

-- Duhem–Quine: remove an auxiliary and the conclusion no longer follows
#guard !(evidenceGraph.derive [noSlipCondition, bernoulliPrinciple, outerFlowIdeal]).contains magnusForce
#guard !(evidenceGraph.derive [noSlipCondition, attachedBoundaryLayer, newtonSecondLaw]).contains magnusForce

-- magnitude and the full model
#guard (evidenceGraph.derive liftFormulaEvidence).contains idealMagnusLift
#guard (evidenceGraph.derive allPhysics).contains curvedFlightPrediction
#guard (evidenceGraph.derive allPhysics).contains flettnerThrust
#guard (evidenceGraph.derive allPhysics).contains magnusEffectModel
#guard (evidenceGraph.derive combinedEvidence).contains magnusBeatsRivals

-- the physics predicts every experiment
#guard evidenceGraph.supports allPhysics tennisBallExperiment
#guard evidenceGraph.supports allPhysics musketBallExperiment
#guard evidenceGraph.supports allPhysics magnusCylinderExperiment
#guard evidenceGraph.supports allPhysics surfacePressureExperiment
#guard evidenceGraph.supports allPhysics windTunnelLiftExperiment
#guard evidenceGraph.supports allPhysics flettnerRotorShipExperiment
#guard !evidenceGraph.supports [noSlipCondition] tennisBallExperiment

-- the rivals are refuted by data
#guard evidenceGraph.refutes [spinIrrelevantModel] tennisBallExperiment
#guard evidenceGraph.refutes [noCirculationFlow] magnusCylinderExperiment
#guard evidenceGraph.refutes [idealLiftIsExact] windTunnelLiftExperiment

-- exclusivity, including contradictions inherited through entailment
#guard evidenceGraph.exclusive magnusEffectModel spinIrrelevantModel
#guard evidenceGraph.exclusive noCirculationFlow circulationAroundSpinner
#guard evidenceGraph.exclusive noCirculationFlow magnusForce
#guard evidenceGraph.exclusive idealLiftIsExact separationLimitsLift

-- sanity
#guard !evidenceGraph.inconsistent combinedEvidence
#guard evidenceGraph.wellFormed

end Scilib.Magnus
