import Scilib.Basic

namespace Scilib.Bernoulli

open Scilib

/-! ## Theories & Core Principles -/

def bernoulliPrinciple : Theory := {
  statement := "Along a streamline in steady flow with no energy added, pressure plus kinetic energy density plus potential energy density is constant."
  sources := ["Daniel Bernoulli, Hydrodynamica, 1738"]
}

def continuityEquation : Theory := {
  statement := "For incompressible flow, the volume flow rate (area times speed) is constant across any cross-section of a pipe."
}

def extendedLossModel : Theory := {
  statement := "Bernoulli's equation extended with a viscous energy-loss term describes real fluid dissipation."
  sources := ["Saleta et al."]
}

def compressibilityModel : Theory := {
  statement := "For compressible flow, the energy equation includes enthalpy changes, causing stagnation pressure rise to exceed the incompressible term by a Mach-dependent factor."
}

def boundarySeparationModel : Theory := {
  statement := "Beyond a critical angle of attack, the boundary layer separates from an airfoil upper surface, causing lift to drop (stall)."
}

/-! ## Domain Assumptions & Overreaches -/

def steadyFlow : Theory := { statement := "The flow is steady over the time of interest." }
def alongStreamline : Theory := { statement := "The points being compared lie on the same streamline." }
def noEnergyAdded : Theory := { statement := "No pump or friction adds/removes energy between points." }
def incompressibleLowSpeed : Theory := { statement := "Density changes are negligible (Mach well below 0.3)." }

def idealAtHighSpeed : Theory := { statement := "Incompressibility is assumed to hold even at moderate subsonic speeds (e.g., Mach 0.6)." }
def idealAtHighAngle : Theory := { statement := "Attached ideal flow is assumed to persist at every arbitrary angle of attack." }
def losslessDrainage : Theory := { statement := "Viscous friction is assumed negligible while a vessel drains through an orifice." }

/-! ## Derived Claims & Predictions -/

def pressureDropsWithSpeed : Theory := { statement := "Along a streamline, static pressure is lower where flow speed is higher." }
def speedUpInConstriction : Theory := { statement := "Incompressible fluid accelerates in a narrower pipe section." }
def venturiPrediction : Theory := { statement := "Static pressure in a venturi throat is lower than at the inlet." }
def lowSpeedLiftPrediction : Theory := { statement := "At low speed and low angle, airfoil lift matches integrated surface pressure differences." }
def highSpeedStagnationPrediction : Theory := { statement := "At Mach 0.6, stagnation pressure rise equals one-half rho v squared." }
def highSpeedDeviationObs : Theory := { statement := "At Mach 0.6, measured stagnation pressure rise exceeds one-half rho v squared by roughly 9 percent." }
def stallPrediction : Theory := { statement := "Lift keeps increasing monotonically as the angle of attack increases." }
def stallObs : Theory := { statement := "Past a critical angle of attack, lift falls due to flow separation." }
def losslessDrainPrediction : Theory := { statement := "A draining vessel follows the lossless Torricelli law exactly." }
def drainDeviationObs : Theory := { statement := "Measured drainage deviates from lossless Torricelli law and requires a viscous energy-loss term." }

/-! ## Raw Experiments -/

def rajkumar1999 : Experiment := {
  protocol := "Measure pressure distribution and direct lift on an airfoil in a low-speed wind tunnel."
  observation := "Pressure varied with speed per Bernoulli; integrated pressure lift matched direct load cell measurements."
  sources := ["Rajkumar, University of Peradeniya, 1999"]
}

def saletaDrainage : Experiment := {
  protocol := "Film a cylindrical vessel draining through an orifice and track fluid level over time."
  observation := "Drainage deviates from lossless Torricelli law and is fitted accurately by an energy-loss term."
  sources := ["Saleta, Tobia, and Gil"]
}

def machPitotTest : Experiment := {
  protocol := "Measure stagnation pressure rise at a Pitot probe in a wind tunnel flow at Mach 0.6."
  observation := "Measured stagnation pressure rise exceeds one-half rho v squared by about 9 percent."
}

def stallTest : Experiment := {
  protocol := "Increase angle of attack of an airfoil at fixed airspeed in a wind tunnel and record lift."
  observation := "Lift rises with angle, then drops past a critical stall angle as flow separates."
}

/-! ## The Evidence Graph -/

def evidenceGraph : Graph := {
  edges := [
    Edge.entails [bernoulliPrinciple, steadyFlow, alongStreamline, noEnergyAdded] pressureDropsWithSpeed "Ideal streamline reduction",
    Edge.entails [continuityEquation, incompressibleLowSpeed] speedUpInConstriction "Continuity in constriction",
    Edge.entails [pressureDropsWithSpeed, speedUpInConstriction] venturiPrediction "Venturi effect",

    Edge.entails [pressureDropsWithSpeed, incompressibleLowSpeed] lowSpeedLiftPrediction "Low-speed pressure-lift link",
    Edge.interprets lowSpeedLiftPrediction rajkumar1999 "Low-speed wind tunnel confirmation",

    Edge.entails [pressureDropsWithSpeed, idealAtHighSpeed] highSpeedStagnationPrediction "Incompressibility overreach at Mach 0.6",
    Edge.contradicts highSpeedStagnationPrediction highSpeedDeviationObs "Compressibility correction",
    Edge.entails [compressibilityModel, steadyFlow, alongStreamline] highSpeedDeviationObs "Compressible energy equation",
    Edge.interprets highSpeedDeviationObs machPitotTest "Pitot stagnation excess",

    Edge.entails [lowSpeedLiftPrediction, idealAtHighAngle] stallPrediction "Infinite attachment overreach",
    Edge.contradicts stallPrediction stallObs "Stall drop conflict",
    Edge.entails [boundarySeparationModel] stallObs "Boundary layer separation",
    Edge.interprets stallObs stallTest "Wind tunnel stall observation",

    Edge.entails [bernoulliPrinciple, steadyFlow, alongStreamline, losslessDrainage] losslessDrainPrediction "Lossless Torricelli overreach",
    Edge.contradicts losslessDrainPrediction drainDeviationObs "Friction loss conflict",
    Edge.entails [extendedLossModel, steadyFlow] drainDeviationObs "Extended loss model",
    Edge.interprets drainDeviationObs saletaDrainage "Drainage dissipation match"
  ]
}

/-! ## Analysis & Guards -/

def experiments : List (String × Experiment) := [
  ("WindTunnel1999", rajkumar1999),
  ("VesselDrainage", saletaDrainage),
  ("Mach0.6Pitot", machPitotTest),
  ("StallTest", stallTest)
]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldIdealBernoulli : List Theory := [
  bernoulliPrinciple, continuityEquation, steadyFlow, alongStreamline,
  noEnergyAdded, incompressibleLowSpeed, idealAtHighSpeed, idealAtHighAngle, losslessDrainage
]

def worldRealFlow : List Theory := [
  bernoulliPrinciple, continuityEquation, extendedLossModel, compressibilityModel,
  boundarySeparationModel, steadyFlow, alongStreamline, noEnergyAdded, incompressibleLowSpeed
]

#eval scoreboard worldIdealBernoulli
#eval scoreboard worldRealFlow

#guard evidenceGraph.wellFormed
#guard evidenceGraph.supports worldIdealBernoulli rajkumar1999
#guard evidenceGraph.refutes worldIdealBernoulli saletaDrainage
#guard evidenceGraph.refutes worldIdealBernoulli machPitotTest
#guard evidenceGraph.refutes worldIdealBernoulli stallTest
#guard evidenceGraph.supports worldRealFlow saletaDrainage
#guard evidenceGraph.supports worldRealFlow machPitotTest
#guard evidenceGraph.supports worldRealFlow stallTest

end Scilib.Bernoulli
