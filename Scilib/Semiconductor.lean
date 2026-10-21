import Scilib.Basic

namespace Scilib.Semiconductor

def semiconductorMaterialsExist : Theory :=
  { statement := "There are materials with semiconductor behavior." }

def siliconIsSemiconductor : Theory :=
  { statement := "The tested crystalline silicon is a semiconductor." }

def germaniumIsSemiconductor : Theory :=
  { statement := "The tested crystalline germanium is a semiconductor." }

def onlyMetalsAndInsulators : Theory :=
  { statement := "Every solid is either a metal or an electrical insulator." }

def activatedCarrierModel : Theory :=
  { statement := "In a crystal with a modest band gap, heat or above-gap light creates mobile charge carriers, and donor dopants can add carriers." }

def semiconductorCriterion : Theory :=
  { statement := "A semiconductor has conductivity governed by charge carriers that can be strongly varied by temperature, light, or doping; intermediate conductivity alone is not sufficient." }

def controlledSiliconSample : Theory :=
  { statement := "The measured sample is identified crystalline silicon, with temperature, illumination, contacts, and dopant concentration controlled." }

def controlledGermaniumSample : Theory :=
  { statement := "The measured sample is identified crystalline germanium, with temperature, illumination, contacts, and dopant concentration controlled." }

def siliconResponseReading : Theory :=
  { statement := "The silicon sample's conductivity rises as it is heated, rises under above-gap illumination, and changes substantially when donor-doped." }

def germaniumResponseReading : Theory :=
  { statement := "The germanium sample's conductivity rises as it is heated, rises under above-gap illumination, and changes substantially when donor-doped." }

def siliconResponseExperiment : Experiment :=
  { protocol := "Measure a crystalline silicon sample's conductivity across a controlled temperature range, in darkness and under above-band-gap light, then compare with a matched donor-doped sample."
    observation := "Conductivity increases with heating and illumination; donor doping substantially changes conductivity."
    sources := ["S. M. Sze and K. K. Ng, Physics of Semiconductor Devices, 3rd ed., 2006"] }

def germaniumResponseExperiment : Experiment :=
  { protocol := "Repeat the temperature, dark-versus-illuminated, and matched donor-doping conductivity measurements on crystalline germanium."
    observation := "Conductivity increases with heating and illumination; donor doping substantially changes conductivity."
    sources := ["S. M. Sze and K. K. Ng, Physics of Semiconductor Devices, 3rd ed., 2006"] }

def evidenceGraph : Graph :=
  { edges :=
      [ Edge.interprets siliconResponseReading siliconResponseExperiment
          "The controlled measurements are read as thermally, optically, and impurity-sensitive conduction."
      , Edge.interprets germaniumResponseReading germaniumResponseExperiment
          "The repeated measurements are read as thermally, optically, and impurity-sensitive conduction."
      , Edge.entails
          [siliconResponseReading, controlledSiliconSample, activatedCarrierModel,
            semiconductorCriterion]
          siliconIsSemiconductor
          "The observed response in an identified sample matches the carrier-based criterion."
      , Edge.entails
          [germaniumResponseReading, controlledGermaniumSample, activatedCarrierModel,
            semiconductorCriterion]
          germaniumIsSemiconductor
          "The independent sample shows the same carrier-based behavior."
      , Edge.implies siliconIsSemiconductor semiconductorMaterialsExist
          "One verified example establishes that semiconductor materials exist."
      , Edge.implies germaniumIsSemiconductor semiconductorMaterialsExist
          "Germanium provides an independent example of the material class."
      , Edge.contradicts onlyMetalsAndInsulators semiconductorMaterialsExist
          "Semiconductor samples show that the metal-or-insulator dichotomy is incomplete."
      ] }

def siliconAssumptions : List Theory :=
  [siliconResponseReading, controlledSiliconSample, activatedCarrierModel,
    semiconductorCriterion]

def germaniumAssumptions : List Theory :=
  [germaniumResponseReading, controlledGermaniumSample, activatedCarrierModel,
    semiconductorCriterion]

#guard evidenceGraph.supports [siliconResponseReading] siliconResponseExperiment
#guard (evidenceGraph.derive siliconAssumptions).contains siliconIsSemiconductor
#guard (evidenceGraph.derive germaniumAssumptions).contains germaniumIsSemiconductor
#guard !(evidenceGraph.derive [siliconResponseReading]).contains siliconIsSemiconductor
#guard (evidenceGraph.derive siliconAssumptions).contains semiconductorMaterialsExist
#guard evidenceGraph.exclusive onlyMetalsAndInsulators semiconductorMaterialsExist

end Scilib.Semiconductor
