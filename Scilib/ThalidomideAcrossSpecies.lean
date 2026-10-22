import Scilib.Basic

/-!
# Thalidomide across species: extrapolation to another system

Domain #9 (extrapolation to another system).  Source facts and their verification:
`parth/sources/thalidomide-across-species/` (ledger.json, REPORT.md).  Primary sources: Donovan et al., "Thalidomide
promotes degradation of SALL4, a transcription factor implicated in Duane Radial Ray syndrome" (eLife 2018), and the
abstract of Yamanaka et al., "Thalidomide and its metabolite 5-hydroxythalidomide induce teratogenicity via the
cereblon neosubstrate PLZF" (EMBO J 2021).  Secondary sources: the review "Molecular Mechanisms of the Teratogenic
Effects of Thalidomide" (Pharmaceuticals 2020), the review of Vargesson (Birth Defects Res C 2015) and two Wikipedia
pages, "Thalidomide" and "Thalidomide scandal".

Graph shape:

* the extrapolation: the rodent record (`rodentNoDefects`) leads to "safe in human pregnancy" (`humanSafe`) only
  together with four hidden assumptions (same target, equivalent dose, same metabolism, same window of development);
  the human outcome refutes the chain, not the rodent record;
* the rivals: each of four explanations of why rodent safety did not carry over contradicts one hidden assumption
  (`doseCause`, `metaboliteCause`, `crbnOnlyCause`, `speciesTarget`);
* the tests: the cell, knock-in mouse and rat records refute the dose, metabolite and cereblon-only rivals one by
  one, while the species-target theory is not refuted by any record.

Not modelled: the doses and the 40-fold gap between the plasma concentration of people (under 10 µM) and the 400 µM
used in chicken and zebrafish embryos, the sensitive period of days 20 to 36 after fertilization in people, the
metabolites of thalidomide that contribute to its effects (the review says human P450 enzymes form them, and no
source says how rodents differ), the antiangiogenic and oxidative-stress theories, the cereblon binding of Ito et
al. 2010 (known here only through two reviews), the limb defects of chicken and zebrafish that the species-target
theory does not explain, the regulatory side of the story (testing on rodents only, the refusal of the FDA), and every
number and error bar.
-/

namespace Scilib.ThalidomideAcrossSpecies

/-! ## Rivals: why rodent safety did not carry over -/

def speciesTarget : Theory :=
  { statement := "Whether thalidomide-bound cereblon degrades a protein depends on the sequences of both cereblon and the protein, which differ between species: thalidomide induces degradation of SALL4 in humans, primates and rabbits but not in rodents or fish, so thalidomide embryopathy is primarily a human disease, with some non-human primates and rabbits more closely resembling the phenotypes."
    sources := ["Donovan et al. 2018"] }

def crbnOnlyCause : Theory :=
  { statement := "A critical polymorphism in mouse cereblon prevents IMiD-dependent degradation of its substrates and could explain the absence of a SALL4-dependent phenotype in mice; expression of human cereblon in mouse cells would then lead to degradation of mouse SALL4 and could render mice sensitive to IMiD-induced birth defects."
    sources := ["Donovan et al. 2018"] }

def metaboliteCause : Theory :=
  { statement := "Only a metabolite of thalidomide formed in the human body, and not the parent drug, is the teratogen, and rodents do not form it, so that rodent safety did not carry over."
    sources := ["Yamanaka et al. 2021"] }

def doseCause : Theory :=
  { statement := "The doses given to rodents, or the times in pregnancy at which they were given, were not enough to show the limb defects that thalidomide causes, so that rodent safety did not carry over."
    sources := ["Donovan et al. 2018"] }

/-! ## The extrapolation and its hidden assumptions (status recorded in `sources`) -/

def humanSafe : Theory :=
  { statement := "Thalidomide taken in pregnancy is safe for the human embryo."
    sources := ["Wikipedia, Thalidomide", "Wikipedia, Thalidomide scandal"] }

def sameTarget : Theory :=
  { statement := "The proteins through which thalidomide harms the embryo are the same in rodents and in humans."
    sources := ["status: suspected", "Donovan et al. 2018"] }

def equivalentDose : Theory :=
  { statement := "The dose given to a rodent embryo is equivalent to the dose reaching the embryo of a pregnant woman."
    sources := ["status: suspected", "Donovan et al. 2018"] }

def sameMetabolism : Theory :=
  { statement := "Rodents and humans turn thalidomide into the same products in the body."
    sources := ["status: suspected", "Yamanaka et al. 2021"] }

def sameWindow : Theory :=
  { statement := "The rodent tests exposed the embryo during the period of development in which thalidomide harms it."
    sources := ["status: suspected", "Vargesson 2015"] }

/-! ## Readings of the records -/

def rodentNoDefects : Theory :=
  { statement := "Thalidomide given to pregnant rodents produced an absence of defining limb deformities, which contributed to the initial approval by regulatory agencies in Europe."
    sources := ["Donovan et al. 2018"] }

def humanDefects : Theory :=
  { statement := "Use of thalidomide in pregnancy led to the birth of thousands of children with severe birth defects, more than 10,000 individuals in all."
    sources := ["Donovan et al. 2018"] }

def primateRabbitDefects : Theory :=
  { statement := "Many non-human primates, and rabbits, exhibit phenotypes that mimic the human syndrome after thalidomide."
    sources := ["Donovan et al. 2018"] }

def v388Pattern : Theory :=
  { statement := "Mice and rats, both insensitive to thalidomide embryopathies, harbor an isoleucine at CRBN position 388, while sensitive primates and rabbits harbor a valine there; the greater bush baby, the only non-human primate known to be insensitive, also harbors an isoleucine."
    sources := ["Donovan et al. 2018"] }

def hsSall4Degraded : Theory :=
  { statement := "Ectopically expressed human SALL4 is readily degraded upon IMiD treatment in human cells, while ectopically expressed mouse SALL4 is unaffected even at arbitrarily high doses of IMiDs."
    sources := ["Donovan et al. 2018"] }

def mouseSall4Immune : Theory :=
  { statement := "Thalidomide does not promote degradation of mouse SALL4 in mouse embryonic stem cells, and expressing human cereblon in mouse cells does not result in degradation of mouse SALL4."
    sources := ["Donovan et al. 2018"] }

def znf2Swap : Theory :=
  { statement := "Five amino acid substitutions that humanize the zinc finger 2 domain of mouse SALL4 induce thalidomide-mediated degradation of mouse SALL4 in a human cell line."
    sources := ["Donovan et al. 2018"] }

def knockinNoEmbryopathy : Theory :=
  { statement := "Mice harboring a homozygous CRBN I391V knock-in allele degrade mouse IKZF1/3, ZFP91 and CSNK1A1 and show increased miscarriage upon IMiD treatment compared with control mice, but they do not exhibit IMiD-induced embryopathies resembling the human phenotype."
    sources := ["Donovan et al. 2018"] }

def sall4Phenocopy : Theory :=
  { statement := "Heterozygous loss of function mutations in SALL4 result in a human developmental condition that phenocopies thalidomide-induced birth defects such as absence of thumbs, phocomelia, defects in ear and eye development, and congenital heart disease."
    sources := ["Donovan et al. 2018"] }

def chickPlzf : Theory :=
  { statement := "In chicken embryos, thalidomide and 5-hydroxythalidomide cause teratogenic phenotypes and induce degradation of PLZF but not of SALL4."
    sources := ["Yamanaka et al. 2021"] }

/-! ## Claims that follow from the records, or that the sources report -/

def ratsAdequateExposure : Theory :=
  { statement := "Rats were given thalidomide in doses up to 4000 mg/kg, and early exposure in rats induced miscarriage and late fetal exposure induced brain damage, but limb defects were not induced."
    sources := ["Molecular Mechanisms review 2020", "Vargesson 2015"] }

def crbnIsTarget : Theory :=
  { statement := "Cereblon is a primary target of thalidomide teratogenicity: overexpressing a mutant cereblon that cannot bind thalidomide reversed the teratogenic phenotypes in chicks and zebrafish."
    sources := ["Molecular Mechanisms review 2020", "Vargesson 2015"] }

def sall4Contributes : Theory :=
  { statement := "Degradation of SALL4 is likely to contribute to the birth defects caused by thalidomide."
    sources := ["Donovan et al. 2018"] }

/-! ## Experiments -/

def rodentTrials : Experiment :=
  { protocol := "Thalidomide was administered to pregnant rodents and the offspring were examined for defining limb deformities."
    observation := "The absence of defining limb deformities following administration to pregnant rodents."
    sources := ["Donovan et al. 2018"] }

def humanExposure : Experiment :=
  { protocol := "Thalidomide was taken in pregnancy as a drug against morning sickness, and the children born were examined."
    observation := "Use of the drug thalidomide led to the birth of thousands of children with severe birth defects, affecting more than 10,000 individuals."
    sources := ["Donovan et al. 2018"] }

def primateTrials : Experiment :=
  { protocol := "Thalidomide was given to pregnant non-human primates and rabbits and the offspring were examined."
    observation := "Many non-human primates exhibit phenotypes that mimic the human syndrome, and rabbits more closely resemble the phenotypes."
    sources := ["Donovan et al. 2018"] }

def crbnSequences : Experiment :=
  { protocol := "The residue at position 388 of cereblon was compared across mice, rats, primates and rabbits that are sensitive or insensitive to thalidomide embryopathies."
    observation := "Mice and rats (both insensitive to thalidomide embryopathies) harbor an isoleucine at CRBN position 388. Sensitive primates have a valine in position 388. The greater bush baby, the only non-human primate known to be insensitive, also harbors an isoleucine at position 388, while all sensitive non-human primates and rabbits harbor the conserved valine."
    sources := ["Donovan et al. 2018"] }

def humanCellAssay : Experiment :=
  { protocol := "Human SALL4 or mouse SALL4 was introduced into human Kelly cells, which were treated with IMiDs, and the SALL4 level was measured."
    observation := "Ectopically expressed hsSALL4 is readily degraded upon IMiD treatment, while mmSALL4 is unaffected even at arbitrarily high doses of IMiDs."
    sources := ["Donovan et al. 2018"] }

def mouseCellAssay : Experiment :=
  { protocol := "Mouse embryonic stem cells were treated with increasing concentrations of thalidomide or pomalidomide, and human cereblon was expressed in mouse cells."
    observation := "Treatment of mouse embryonic stem cells with increasing concentrations of thalidomide or pomalidomide does not promote degradation of mmSALL4, and expression of hsCRBN in mouse cells does not result in degradation of mmSALL4."
    sources := ["Donovan et al. 2018"] }

def znf2SwapAssay : Experiment :=
  { protocol := "Five amino acids of the zinc finger 2 domain of mouse SALL4 were changed to the human residues, and the protein was tested for degradation by thalidomide in a human cell line."
    observation := "Through the five amino acid substitutions required to humanize the mmSALL4 ZnF2 domain, thalidomide-mediated mouse SALL4 degradation was induced in a human cell line."
    sources := ["Donovan et al. 2018"] }

def knockinMice : Experiment :=
  { protocol := "Mice harboring a homozygous CRBN I391V knock-in allele and control mice were treated with IMiDs during pregnancy."
    observation := "Mice harboring a homozygous CRBN I391V knock-in allele show degradation of mmIKZF1/3, mmZFP91, and mmCSNK1A1 and increased miscarriage upon IMiD treatment compared with control mice; they do not exhibit IMiD-induced embryopathies resembling the human phenotype."
    sources := ["Donovan et al. 2018"] }

def chickPlzfAssay : Experiment :=
  { protocol := "Chicken embryos were treated with thalidomide or 5-hydroxythalidomide, and the degradation of PLZF and SALL4 and the limb phenotype were examined."
    observation := "Thalidomide and 5-hydroxythalidomide cause teratogenic phenotypes in chicken embryos. Degradation of PLZF protein, but not of SALL4, was induced by thalidomide or 5-hydroxythalidomide treatment in chicken embryos."
    sources := ["Yamanaka et al. 2021"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- the record and its readings
        Edge.interprets rodentNoDefects rodentTrials
      , Edge.interprets humanDefects humanExposure
      , Edge.interprets primateRabbitDefects primateTrials
      , Edge.interprets v388Pattern crbnSequences
      , Edge.interprets hsSall4Degraded humanCellAssay
      , Edge.interprets mouseSall4Immune mouseCellAssay
      , Edge.interprets znf2Swap znf2SwapAssay
      , Edge.interprets knockinNoEmbryopathy knockinMice
      , Edge.interprets chickPlzf chickPlzfAssay
        -- the extrapolation from the rodent record to the human embryo
      , Edge.entails [rodentNoDefects, sameTarget, equivalentDose, sameMetabolism, sameWindow] humanSafe
          "No limb defects in rodents mean safety in people only if the target, the dose, the metabolism and the window of development are all the same in rodents and in people."
      , Edge.contradicts humanSafe humanDefects
          "Thalidomide cannot be safe in pregnancy and also have caused thousands of birth defects."
        -- the rivals, each denying one hidden assumption
      , Edge.contradicts sameTarget speciesTarget
          "If the proteins degraded differ between species, the target is not the same."
      , Edge.contradicts sameTarget crbnOnlyCause
          "If the cereblon of mice differs in a way that blocks degradation, the target is not the same."
      , Edge.contradicts sameMetabolism metaboliteCause
          "If only a metabolite formed in the human body is the teratogen, rodents and humans do not make the same products."
      , Edge.contradicts equivalentDose doseCause
          "If rodents were given too little, the dose is not equivalent."
      , Edge.contradicts sameWindow doseCause
          "If rodents were given the drug at the wrong time in pregnancy, the window is not the same."
      , Edge.implies speciesTarget rodentNoDefects
          "If thalidomide does not degrade SALL4 in rodents, they show no limb defects."
      , Edge.implies speciesTarget humanDefects
          "If thalidomide degrades SALL4 in people, the embryo is harmed."
      , Edge.implies crbnOnlyCause rodentNoDefects
          "If mouse cereblon blocks degradation, mice show no SALL4-dependent defects."
      , Edge.implies crbnOnlyCause humanDefects
          "Human cereblon degrades SALL4, so the human embryo is harmed."
      , Edge.implies metaboliteCause rodentNoDefects
          "If rodents do not form the teratogenic metabolite, they show no defects."
      , Edge.implies metaboliteCause humanDefects
          "If people form the teratogenic metabolite, the embryo is harmed."
      , Edge.implies doseCause rodentNoDefects
          "If the dose or the timing was not enough, no defects were seen."
      , Edge.implies doseCause humanDefects
          "The drug harms the embryo of every species at the right dose and time, people included."
        -- the tests of the rivals
      , Edge.nogood [doseCause, ratsAdequateExposure]
          "Doses up to 4000 mg/kg, with miscarriage after early exposure and brain damage after late exposure, are not too little or at the wrong time."
      , Edge.nogood [metaboliteCause, hsSall4Degraded]
          "If only a metabolite were active, the parent drug would not degrade human SALL4 in cells."
      , Edge.nogood [metaboliteCause, chickPlzf]
          "If only a metabolite were active, the parent drug would not cause teratogenic phenotypes in chicken embryos."
      , Edge.nogood [crbnOnlyCause, mouseSall4Immune]
          "If only cereblon differed, human cereblon in mouse cells would degrade mouse SALL4."
      , Edge.nogood [crbnOnlyCause, knockinNoEmbryopathy]
          "If only cereblon differed, mice with a human-like cereblon would show the embryopathy."
        -- the species-target theory and what it explains
      , Edge.implies speciesTarget crbnIsTarget
          "Degradation by thalidomide-bound cereblon makes cereblon the target."
      , Edge.implies crbnOnlyCause crbnIsTarget
          "A cereblon polymorphism explains the species difference only if cereblon is the target."
      , Edge.implies speciesTarget primateRabbitDefects
          "SALL4 is degraded in primates and rabbits, so they show the human phenotype."
      , Edge.implies speciesTarget v388Pattern
          "The residue at position 388 decides whether cereblon binds and degrades the target."
      , Edge.implies speciesTarget hsSall4Degraded
          "Human SALL4 is degraded, mouse SALL4 is not."
      , Edge.implies speciesTarget mouseSall4Immune
          "Mouse SALL4 stays intact even with human cereblon."
      , Edge.implies speciesTarget znf2Swap
          "The sequence of SALL4 decides, so humanizing its zinc finger 2 makes it degradable."
      , Edge.implies speciesTarget knockinNoEmbryopathy
          "Mouse SALL4 stays intact in mice with a human-like cereblon."
      , Edge.implies speciesTarget chickPlzf
          "Which protein is degraded differs between species: PLZF in chicken, SALL4 in people."
      , Edge.entails [hsSall4Degraded, sall4Phenocopy] sall4Contributes
          "Thalidomide degrades SALL4, and losing SALL4 gives the same defects."
      ] }

/-- Named checks; the verifier mutates the graph and runs these on every mutant. -/
def checks (g : Graph) : List (String × Bool) :=
  [ ("graph is well formed", g.wellFormed)
    -- readings
  , ("rodent reading", g.readings.contains (rodentNoDefects, rodentTrials))
  , ("human reading", g.readings.contains (humanDefects, humanExposure))
  , ("primate and rabbit reading", g.readings.contains (primateRabbitDefects, primateTrials))
  , ("sequence reading", g.readings.contains (v388Pattern, crbnSequences))
  , ("human cell reading", g.readings.contains (hsSall4Degraded, humanCellAssay))
  , ("mouse cell reading", g.readings.contains (mouseSall4Immune, mouseCellAssay))
  , ("zinc finger swap reading", g.readings.contains (znf2Swap, znf2SwapAssay))
  , ("knock-in mouse reading", g.readings.contains (knockinNoEmbryopathy, knockinMice))
  , ("chicken PLZF reading", g.readings.contains (chickPlzf, chickPlzfAssay))
    -- the extrapolation needs every hidden assumption
  , ("the rodent record gives safety with four assumptions",
      (g.derive [rodentNoDefects, sameTarget, equivalentDose, sameMetabolism, sameWindow]).contains humanSafe)
  , ("safety needs the rodent record",
      !(g.derive [sameTarget, equivalentDose, sameMetabolism, sameWindow]).contains humanSafe)
  , ("safety needs the same target",
      !(g.derive [rodentNoDefects, equivalentDose, sameMetabolism, sameWindow]).contains humanSafe)
  , ("safety needs the equivalent dose",
      !(g.derive [rodentNoDefects, sameTarget, sameMetabolism, sameWindow]).contains humanSafe)
  , ("safety needs the same metabolism",
      !(g.derive [rodentNoDefects, sameTarget, equivalentDose, sameWindow]).contains humanSafe)
  , ("safety needs the same window",
      !(g.derive [rodentNoDefects, sameTarget, equivalentDose, sameMetabolism]).contains humanSafe)
  , ("safe and harmful are exclusive", g.exclusive humanSafe humanDefects)
    -- the human outcome refutes the chain, not the rodent record
  , ("the human outcome refutes the chain",
      g.refutes [rodentNoDefects, sameTarget, equivalentDose, sameMetabolism, sameWindow] humanExposure)
  , ("the refutation needs the rodent record",
      !g.refutes [sameTarget, equivalentDose, sameMetabolism, sameWindow] humanExposure)
  , ("the refutation needs the same target",
      !g.refutes [rodentNoDefects, equivalentDose, sameMetabolism, sameWindow] humanExposure)
  , ("the refutation needs the equivalent dose",
      !g.refutes [rodentNoDefects, sameTarget, sameMetabolism, sameWindow] humanExposure)
  , ("the refutation needs the same metabolism",
      !g.refutes [rodentNoDefects, sameTarget, equivalentDose, sameWindow] humanExposure)
  , ("the refutation needs the same window",
      !g.refutes [rodentNoDefects, sameTarget, equivalentDose, sameMetabolism] humanExposure)
  , ("the rodent record is consistent with the human outcome", !g.inconsistent [rodentNoDefects, humanDefects])
  , ("the chain is inconsistent with the human outcome",
      g.inconsistent [rodentNoDefects, sameTarget, equivalentDose, sameMetabolism, sameWindow, humanDefects])
    -- the rivals each deny one assumption
  , ("the species target denies the same target", g.exclusive sameTarget speciesTarget)
  , ("the cereblon-only cause denies the same target", g.exclusive sameTarget crbnOnlyCause)
  , ("the metabolite denies the same metabolism", g.exclusive sameMetabolism metaboliteCause)
  , ("the dose denies the equivalent dose", g.exclusive equivalentDose doseCause)
  , ("the dose denies the same window", g.exclusive sameWindow doseCause)
  , ("the species target does not deny the dose", !g.exclusive equivalentDose speciesTarget)
  , ("each rival explains the rodent record",
      [speciesTarget, crbnOnlyCause, metaboliteCause, doseCause].all fun r => g.supports [r] rodentTrials)
  , ("each rival explains the human record",
      [speciesTarget, crbnOnlyCause, metaboliteCause, doseCause].all fun r => g.supports [r] humanExposure)
  , ("each rival alone is consistent",
      [speciesTarget, crbnOnlyCause, metaboliteCause, doseCause].all fun r => !g.inconsistent [r])
    -- the rivals refuted one by one
  , ("the dose rival is refuted by the rat exposure", g.inconsistent [doseCause, ratsAdequateExposure])
  , ("the metabolite rival is refuted by the human cells", g.refutes [metaboliteCause] humanCellAssay)
  , ("the metabolite rival is refuted by the chicken", g.refutes [metaboliteCause] chickPlzfAssay)
  , ("the cereblon-only rival is refuted by the mouse cells", g.refutes [crbnOnlyCause] mouseCellAssay)
  , ("the cereblon-only rival is refuted by the knock-in mice", g.refutes [crbnOnlyCause] knockinMice)
  , ("the metabolite rival survives the mouse cells", !g.refutes [metaboliteCause] mouseCellAssay)
  , ("the metabolite rival survives the knock-in mice", !g.refutes [metaboliteCause] knockinMice)
  , ("the cereblon-only rival survives the human cells", !g.refutes [crbnOnlyCause] humanCellAssay)
  , ("the cereblon-only rival survives the primates", !g.refutes [crbnOnlyCause] primateTrials)
  , ("the dose rival survives the cells", !g.refutes [doseCause] mouseCellAssay)
    -- the species-target theory
  , ("the species target explains the primates and rabbits", g.supports [speciesTarget] primateTrials)
  , ("the species target explains the sequence pattern", g.supports [speciesTarget] crbnSequences)
  , ("the species target explains the human cells", g.supports [speciesTarget] humanCellAssay)
  , ("the species target explains the mouse cells", g.supports [speciesTarget] mouseCellAssay)
  , ("the species target explains the zinc finger swap", g.supports [speciesTarget] znf2SwapAssay)
  , ("the species target explains the knock-in mice", g.supports [speciesTarget] knockinMice)
  , ("the species target explains the chicken PLZF", g.supports [speciesTarget] chickPlzfAssay)
  , ("the species target makes cereblon the target", (g.derive [speciesTarget]).contains crbnIsTarget)
  , ("the cereblon-only cause makes cereblon the target", (g.derive [crbnOnlyCause]).contains crbnIsTarget)
  , ("no record refutes the species target",
      [rodentTrials, humanExposure, primateTrials, crbnSequences, humanCellAssay,
        mouseCellAssay, znf2SwapAssay, knockinMice, chickPlzfAssay].all
        fun e => !g.refutes [speciesTarget] e)
  , ("the species target is consistent with the whole record",
      !g.inconsistent [speciesTarget, rodentNoDefects, humanDefects, primateRabbitDefects, v388Pattern,
        hsSall4Degraded, mouseSall4Immune, znf2Swap, knockinNoEmbryopathy, sall4Phenocopy,
        chickPlzf, ratsAdequateExposure])
    -- SALL4 and the birth defects
  , ("SALL4 degradation and the genetics give the contribution",
      (g.derive [hsSall4Degraded, sall4Phenocopy]).contains sall4Contributes)
  , ("the contribution needs the degradation", !(g.derive [sall4Phenocopy]).contains sall4Contributes)
  , ("the contribution needs the genetics", !(g.derive [hsSall4Degraded]).contains sall4Contributes)
  ]

#guard (checks evidenceGraph).all (·.2)

end Scilib.ThalidomideAcrossSpecies
