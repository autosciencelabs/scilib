import Scilib.Basic

/-!
# The Leidenfrost effect: why water skittering on a hot pan lives so long

A water drop on a pan far above 100 °C does not boil away at once.  It floats on
its own vapour, glides around almost without friction, and survives for tens of
seconds.  This file ties together several classical laws in one graph:

* latent heat (energy conservation in evaporation),
* Fourier conduction through a thin layer,
* lubrication (viscous) flow of the vapour escaping from under the drop,
* force balance (vapour pressure carries the drop's weight),
* Newton's law of viscosity (why gliding is nearly frictionless),
* Young–Laplace + hydrostatics (why big drops flatten into puddles).

Rival theory: the drop stays in wetting contact and keeps boiling violently.

History (sources are listed on the experiments; verify before merging):
* 1732  Boerhaave describes drops lingering on very hot surfaces.
* 1756  Leidenfrost's tract on water drops on a hot iron spoon.
* 1934  Nukiyama measures the boiling curve (heat flux peaks, then collapses).
* 1966  Gottfried, Lee & Bell: quantitative drop lifetimes; Leidenfrost's tract
        is translated into English.
* 2003  Biance, Clanet & Quéré: vapour gap, puddle thickness, lubrication model.
* 2006  Linke et al.: drops self-propel on ratchet-shaped surfaces.
-/

namespace Scilib.Leidenfrost

/-! ## Laws and empirical facts used as auxiliary hypotheses -/

def latentHeatLaw : Theory :=
  { statement := "Heat absorbed by a boiling liquid equals the evaporated mass times the latent heat of vaporisation."
    sources := ["J. Black, latent heat, 1760s"] }

def fourierConduction : Theory :=
  { statement := "Steady conductive heat flux across a thin layer equals thermal conductivity times temperature difference divided by layer thickness."
    sources := ["J. Fourier, Théorie analytique de la chaleur, 1822"] }

def lowVapourConductivity : Theory :=
  { statement := "Water vapour conducts heat far worse than liquid water or a metal." }

def lubricationFlow : Theory :=
  { statement := "Viscous gas squeezed out radially from a thin gap under a drop obeys lubrication theory: the supporting pressure grows as the gap thins."
    sources := ["O. Reynolds, On the theory of lubrication, Phil. Trans. 177, 1886"] }

def forceBalance : Theory :=
  { statement := "A drop at rest on a gas film is in equilibrium: film pressure integrated over the contact area balances the drop's weight." }

def newtonViscosity : Theory :=
  { statement := "Shear stress in a thin fluid layer equals viscosity times velocity gradient across it."
    sources := ["I. Newton, Principia, 1687"] }

def lowVapourViscosity : Theory :=
  { statement := "Water vapour is far less viscous than liquid water." }

def laplacePressure : Theory :=
  { statement := "Pressure jump across a curved liquid surface equals surface tension times mean curvature."
    sources := ["T. Young, 1805; P.-S. Laplace, 1806"] }

def hydrostaticPressure : Theory :=
  { statement := "Pressure in a liquid at rest increases linearly with depth: density times g times depth." }

/-! ## Rival theory -/

def directContactBoiling : Theory :=
  { statement := "The drop stays in wetting contact with the hot surface and keeps boiling violently, so heat flux keeps rising with surface temperature." }

/-! ## Readings (interpretations of raw records) -/

def nonWettingReading : Theory :=
  { statement := "The drop stays rounded, rolls freely and does not wet the surface." }

def lifetimeJumpReading : Theory :=
  { statement := "Above a threshold surface temperature, heat transfer into the drop drops sharply, so its lifetime jumps." }

def heatFluxCollapseReading : Theory :=
  { statement := "Past its peak, heat flux into the liquid collapses to a much lower value as surface temperature rises." }

def vapourGapReading : Theory :=
  { statement := "A continuous vapour layer tens of micrometres thick lies between the drop and the plate." }

def flatteningReading : Theory :=
  { statement := "Large drops are flattened by gravity against surface tension into puddles of nearly fixed thickness." }

def asymmetricGlideReading : Theory :=
  { statement := "On an asymmetric sawtooth surface, vapour flow pushes the drop steadily in one direction." }

/-! ## Derived claims -/

def vapourFilmExists : Theory :=
  { statement := "A continuous vapour film separates the drop from the hot surface." }

def dropInsulated : Theory :=
  { statement := "The vapour film thermally insulates the drop, so heat flux into it is small and evaporation is slow." }

def dropLevitates : Theory :=
  { statement := "The drop floats on the vapour film without touching the hot surface." }

def dropSkitters : Theory :=
  { statement := "The levitating drop glides over the surface with very little friction." }

def capillaryLength : Theory :=
  { statement := "Gravity and surface tension balance at the capillary length, which sets the size at which drops flatten." }

def puddleThickness : Theory :=
  { statement := "Large levitating drops flatten into puddles whose thickness is set by the capillary length, not by the volume." }

def ratchetPropulsion : Theory :=
  { statement := "An asymmetric surface texture can drive a Leidenfrost drop in a preferred direction." }

def leidenfrostEffect : Theory :=
  { statement := "Above the Leidenfrost temperature a drop floats, insulated and nearly frictionless, on its own vapour film." }

/-! ## Raw experiments -/

def spoonExperiment : Experiment :=
  { protocol := "Place a water drop on an iron spoon heated well above the boiling point of water and watch it."
    observation := "The drop stays rounded, rolls around without wetting the spoon, and lasts much longer than on a moderately hot spoon."
    sources := ["J. G. Leidenfrost, De aquae communis nonnullis qualitatibus tractatus, 1756"] }

def boilingCurveExperiment : Experiment :=
  { protocol := "Heat a submerged wire in saturated water at controlled temperatures and measure heat flux through its surface."
    observation := "Heat flux rises with wire temperature, peaks, then falls sharply to a much lower value at higher temperature."
    sources := ["S. Nukiyama, J. Soc. Mech. Eng. Japan 37, 1934"] }

def lifetimeExperiment : Experiment :=
  { protocol := "Place equal water drops on a polished plate held at fixed temperatures and time each until it disappears."
    observation := "Lifetime shortens as plate temperature rises, then increases sharply above a threshold temperature."
    sources := ["B. S. Gottfried, C. J. Lee, K. J. Bell, Int. J. Heat Mass Transfer 9, 1167, 1966"] }

def gapImagingExperiment : Experiment :=
  { protocol := "Image a drop from the side on a plate far above the threshold temperature."
    observation := "A thin continuous gap, tens of micrometres thick, separates the drop from the plate."
    sources := ["A.-L. Biance, C. Clanet, D. Quéré, Phys. Fluids 15, 1632, 2003"] }

def puddleExperiment : Experiment :=
  { protocol := "Deposit increasing water volumes on a very hot plate and view them from the side."
    observation := "Small drops stay nearly spherical; large ones flatten into puddles whose thickness stays about the same as volume grows."
    sources := ["A.-L. Biance, C. Clanet, D. Quéré, Phys. Fluids 15, 1632, 2003"] }

def ratchetExperiment : Experiment :=
  { protocol := "Place drops on a heated plate with an asymmetric sawtooth surface and track their motion."
    observation := "Drops accelerate in one fixed direction along the teeth with no external push."
    sources := ["H. Linke et al., Phys. Rev. Lett. 96, 154502, 2006"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ Edge.interprets nonWettingReading spoonExperiment
          "A rounded, freely rolling drop is read as non-wetting."
      , Edge.interprets heatFluxCollapseReading boilingCurveExperiment
          "The post-peak drop in flux is read as a collapse of heat transfer."
      , Edge.interprets lifetimeJumpReading lifetimeExperiment
          "The sudden lifetime increase is read as a heat-transfer drop."
      , Edge.interprets vapourGapReading gapImagingExperiment
          "The side-view gap is read as a vapour layer."
      , Edge.interprets flatteningReading puddleExperiment
          "The volume-independent thickness is read as flattening into a puddle."
      , Edge.interprets asymmetricGlideReading ratchetExperiment
          "The one-way acceleration is read as vapour flow rectified by the texture."
      , Edge.entails [vapourGapReading] vapourFilmExists
          "Direct imaging of a gap: the film is observed."
      , Edge.entails [heatFluxCollapseReading, fourierConduction, lowVapourConductivity]
          vapourFilmExists
          "A flux collapse is what a thin, poorly conducting vapour layer would cause."
      , Edge.entails [lifetimeJumpReading, latentHeatLaw, fourierConduction, lowVapourConductivity]
          vapourFilmExists
          "Lifetime is latent heat divided by heat flux, so a long lifetime means low flux through a vapour layer."
      , Edge.entails [vapourFilmExists, fourierConduction, lowVapourConductivity]
          dropInsulated
          "Thin layer plus low conductivity gives low conductive flux."
      , Edge.entails [nonWettingReading] dropLevitates
          "Observation route: a non-wetting, freely rolling drop is not touching the surface."
      , Edge.entails [vapourFilmExists, lubricationFlow, forceBalance] dropLevitates
          "Mechanism route: lubrication pressure in the film carries the drop's weight."
      , Edge.entails [dropLevitates, newtonViscosity, lowVapourViscosity] dropSkitters
          "A thin, low-viscosity layer exerts very little shear drag."
      , Edge.entails [laplacePressure, hydrostaticPressure] capillaryLength
          "Balancing curvature pressure against hydrostatic pressure gives the capillary length."
      , Edge.entails [flatteningReading, capillaryLength, dropLevitates] puddleThickness
          "A floating drop larger than the capillary length is flattened to a thickness set by it."
      , Edge.entails [asymmetricGlideReading, dropSkitters, lubricationFlow] ratchetPropulsion
          "Low friction plus rectified vapour flow lets texture steer the drop."
      , Edge.entails [dropInsulated, dropLevitates, dropSkitters] leidenfrostEffect
          "Insulation, levitation and low friction together are the Leidenfrost effect."
      , Edge.implies leidenfrostEffect dropLevitates
          "The full effect includes levitation (special case of the whole)."
      , Edge.contradicts directContactBoiling dropLevitates
          "A drop cannot both touch the surface and float above it."
      , Edge.contradicts directContactBoiling heatFluxCollapseReading
          "Heat flux cannot both keep rising and collapse."
      ] }

/-! ## Granted bundles -/

def mechanismLaws : List Theory :=
  [latentHeatLaw, fourierConduction, lowVapourConductivity, lubricationFlow,
    forceBalance, newtonViscosity, lowVapourViscosity, laplacePressure,
    hydrostaticPressure]

def observations : List Theory :=
  [nonWettingReading, lifetimeJumpReading, heatFluxCollapseReading,
    vapourGapReading, flatteningReading, asymmetricGlideReading]

def allGranted : List Theory := mechanismLaws ++ observations

/-! ## Checks -/

-- the full argument goes through
#guard (evidenceGraph.derive allGranted).contains leidenfrostEffect
#guard !(evidenceGraph.inconsistent allGranted)
#guard evidenceGraph.wellFormed

-- three independent routes to the vapour film
#guard (evidenceGraph.derive [vapourGapReading]).contains vapourFilmExists
#guard (evidenceGraph.derive
  [heatFluxCollapseReading, fourierConduction, lowVapourConductivity]).contains vapourFilmExists
#guard (evidenceGraph.derive
  [lifetimeJumpReading, latentHeatLaw, fourierConduction, lowVapourConductivity]).contains vapourFilmExists

-- two independent routes to levitation
#guard (evidenceGraph.derive [nonWettingReading]).contains dropLevitates
#guard (evidenceGraph.derive [vapourGapReading, lubricationFlow, forceBalance]).contains dropLevitates

-- connected laws reach the other phenomena
#guard (evidenceGraph.derive
  [flatteningReading, laplacePressure, hydrostaticPressure, nonWettingReading]).contains puddleThickness
#guard (evidenceGraph.derive
  [asymmetricGlideReading, nonWettingReading, newtonViscosity, lowVapourViscosity,
    lubricationFlow]).contains ratchetPropulsion

-- Duhem–Quine: drop an auxiliary and the conclusion no longer follows
#guard !(evidenceGraph.derive [vapourGapReading, fourierConduction]).contains dropInsulated
#guard !(evidenceGraph.derive [nonWettingReading, newtonViscosity]).contains dropSkitters

-- every experiment is supported by its reading
#guard evidenceGraph.supports allGranted spoonExperiment
#guard evidenceGraph.supports allGranted boilingCurveExperiment
#guard evidenceGraph.supports allGranted lifetimeExperiment
#guard evidenceGraph.supports allGranted gapImagingExperiment
#guard evidenceGraph.supports allGranted puddleExperiment
#guard evidenceGraph.supports allGranted ratchetExperiment
#guard !(evidenceGraph.supports [] spoonExperiment)

-- the rival theory is refuted, and the conflict is inherited by the full effect
#guard evidenceGraph.refutes [directContactBoiling] spoonExperiment
#guard evidenceGraph.refutes [directContactBoiling] boilingCurveExperiment
#guard evidenceGraph.exclusive directContactBoiling dropLevitates
#guard evidenceGraph.exclusive directContactBoiling leidenfrostEffect

end Scilib.Leidenfrost
