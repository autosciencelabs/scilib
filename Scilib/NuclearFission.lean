import Scilib.Basic

namespace Scilib.NuclearFission

/-! ## Theories & Models -/

def fermiTransuranicHypothesis : Theory where
  statement := "Neutron bombardment of uranium yields transuranic elements (Z > 92) via gradual beta decay series."
  sources := ["Enrico Fermi, 1934"]

def liquidDropFissionModel : Theory where
  statement := "A heavy nucleus absorbing a neutron undergoes collective oscillation and splits into two roughly equal lighter fragments (nuclear fission)."
  sources := ["Lise Meitner & Otto Frisch, 1939"]


/-! ## Experimental Probes & Regimes -/

def neutronBombardmentSetup : Theory where
  statement := "Uranium target exposed to a radon-beryllium neutron source."
  sources := ["Radiochemistry standard setup"]


/-! ## Derived Claims & Predictions -/

def transuranicProductsExpected : Theory :=
  { statement := "Chemical separation of irradiated uranium should yield heavy elements with atomic numbers greater than 92." }

def bariumFragmentProduced : Theory :=
  { statement := "Neutron irradiation of uranium produces radioactive isotopes of barium (Z = 56) and other mid-mass elements." }


/-! ## Raw Experiments -/

def hahnStrassmann1938 : Experiment where
  protocol := "Irradiate uranium with neutrons, use barium salts as a chemical carrier, and test for Group 2 radioactivity."
  observation := "Radioactivity precipitates cleanly with barium carrier rather than radium or heavier actinides, proving the presence of barium."
  sources := ["Otto Hahn & Fritz Strassmann, December 1938"]


/-! ## The Evidence Graph -/

def evidenceGraph : Graph where
  edges := [
    Edge.implies fermiTransuranicHypothesis transuranicProductsExpected,
    Edge.contradicts transuranicProductsExpected bariumFragmentProduced,

    Edge.implies liquidDropFissionModel bariumFragmentProduced,
    Edge.entails [bariumFragmentProduced, neutronBombardmentSetup] bariumFragmentProduced,
    Edge.interprets bariumFragmentProduced hahnStrassmann1938
      "Liquid-drop fission model successfully explains the appearance of barium isotopes in neutron-irradiated uranium."
  ]


/-! ## Analysis & Scoreboards -/

def experiments : List (String × Experiment) :=
  [ ("HahnStrassmann1938", hahnStrassmann1938) ]

def verdict (world : List Theory) (e : Experiment) : String :=
  if evidenceGraph.refutes world e then "refuted"
  else if evidenceGraph.supports world e then "supported"
  else "silent"

def scoreboard (world : List Theory) : List (String × String) :=
  experiments.map fun (name, e) => (name, verdict world e)

def worldFermiTransuranic : List Theory := [
  fermiTransuranicHypothesis,
  neutronBombardmentSetup
]

def worldMeitnerFrischFission : List Theory := [
  liquidDropFissionModel,
  neutronBombardmentSetup
]

#eval scoreboard worldFermiTransuranic
#eval scoreboard worldMeitnerFrischFission


/-! ## Compilation Guards -/

#guard evidenceGraph.wellFormed
#guard evidenceGraph.refutes worldFermiTransuranic hahnStrassmann1938
#guard evidenceGraph.supports worldMeitnerFrischFission hahnStrassmann1938

end Scilib.NuclearFission
