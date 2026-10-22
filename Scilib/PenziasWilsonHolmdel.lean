import Scilib.Basic

/-!
# Penzias-Wilson, Holmdel 6 m horn antenna (1964-65): exploratory discovery

Domain #7 (exploratory discovery: record kept apart from reading).  Source facts and their verification:
`parth/sources/penzias-wilson-holmdel-6-m-horn-antenna-1964-65/` (ledger.json, REPORT.md).  Primary sources:
the letter of Penzias and Wilson (Astrophysical Journal 142, 419, 1965), the companion letter of Dicke, Peebles,
Roll and Wilkinson (142, 414) and the Nobel lecture of R. W. Wilson (1978).  Secondary sources: Wikipedia,
"Discovery of cosmic microwave background radiation", "Holmdel Horn Antenna", "Steady-state model" and
"Cosmic microwave background".

Graph shape:

* the record: the antenna, elevation, antenna-check, ground-check, year-long, survey, Roll-Wilkinson and CN
  experiments each keep what was recorded; the readings sit on `Edge.interprets` edges;
* the subtraction: the excess antenna temperature (`excessTemp`) follows from the total, the atmosphere, the ohmic
  loss and the back lobes only with the calibration of the reference termination, a hidden assumption;
* the systematics ruled out one by one: each candidate source of the noise (`antennaLossCause`,
  `groundPickupCause`, `knownSourcesCause`, `solarOrBeltsCause`, `atmosphereDoubled`) forbids one reading, so
  the matching experiment refutes it;
* the reading the authors did not make: the relic radiation (`relicRadiation`) is not a reading of the antenna
  record in their letter; it comes from the companion letter, and the steady-state assumption excludes it.

Not modelled: that no combination of the listed causes is shown to be the only possibility (the language has no
disjunction, so elimination does not make the relic reading true), the uncertainties of every number and the
way they were summed (maximum error, not statistical), the first prediction of 10 K or more from Princeton against 3.5 K, the earlier
excess of about 3 K in the systems of DeGrasse et al. and Ohm, the later spectrum of COBE, the dates of the
measurements, the scattered-starlight form of the steady-state explanation, and the account of Wilson that
cleaning gave only a minor reduction against the statement of the letter that taping gave no change.
-/

namespace Scilib.PenziasWilsonHolmdel

/-! ## Rivals -/

def relicRadiation : Theory :=
  { statement := "The universe may have been extremely hot in its early stages and be filled with black-body radiation from that high-temperature state, which the cosmological redshift has cooled while preserving its thermal character."
    sources := ["Dicke, Peebles, Roll and Wilkinson 1965"] }

def steadyState : Theory :=
  { statement := "The universe has been expanding for all time, with a continuous but slow creation of new matter in the universe."
    sources := ["Dicke, Peebles, Roll and Wilkinson 1965"] }

/-! ## Candidate sources of the noise, each tested in the course of the work -/

def antennaLossCause : Theory :=
  { statement := "Losses in the antenna horn due to imperfections in its seams, or the white material left by a pair of pigeons roosting in the horn, might account for the excess antenna temperature."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def groundPickupCause : Theory :=
  { statement := "Man-made noise picked up by the antenna, or a uniform 3 K picked up from the earth, might account for the excess antenna temperature."
    sources := ["Wilson 1978"] }

def knownSourcesCause : Theory :=
  { statement := "Radiation from our galaxy, or from discrete radio sources of types known to exist, might account for the excess antenna temperature."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def solarOrBeltsCause : Theory :=
  { statement := "A source in the solar system, or the ionized particles that a high-altitude nuclear explosion in 1962 put into the Van Allen belts, might account for the excess antenna temperature."
    sources := ["Wilson 1978"] }

def atmosphereDoubled : Theory :=
  { statement := "The microwave absorption of the earth's atmosphere is about twice the value that was used, so that the sky temperature is about 5 K instead of 2.5 K."
    sources := ["Wilson 1978"] }

/-! ## Auxiliaries (status recorded in `sources`) -/

def coldLoadCalibrated : Theory :=
  { statement := "The temperature of the liquid-helium-cooled reference termination is known: 4.2 K plus the contribution of the waveguide above the liquid level, calculated from the temperature distribution along the waveguide."
    sources := ["status: declared", "Wilson 1978", "Penzias and Wilson 1965"] }

def noOtherCnExcitation : Theory :=
  { statement := "There is no other significant source of excitation where the CN molecules are located."
    sources := ["status: declared", "Wilson 1978"] }

/-! ## Readings of the records -/

def totalTemp : Theory :=
  { statement := "The total antenna temperature measured at the zenith is 6.7 K, with an estimated error of 0.3 K that comes largely from uncertainty in the absolute calibration of the reference termination."
    sources := ["Penzias and Wilson 1965"] }

def atmosphereTemp : Theory :=
  { statement := "The contribution to the antenna temperature due to atmospheric absorption, obtained from the variation of antenna temperature with elevation angle and the secant law, is 2.3 K, in good agreement with published values."
    sources := ["Penzias and Wilson 1965"] }

def antennaChecksNull : Theory :=
  { statement := "Taping all the seams in the section near the throat and most of the others with aluminum tape caused no observable change in antenna temperature, and evicting the pigeons and cleaning up their mess obtained only a small reduction in antenna temperature."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def groundQuiet : Theory :=
  { statement := "The average back-lobe level of the antenna is more than 30 db below isotropic response, and pointing the antenna to New York City or any other direction on the horizon never raised the antenna temperature significantly above the thermal temperature of the earth."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def excessIsotropic : Theory :=
  { statement := "The excess temperature is, within the limits of the observations, isotropic and unpolarized."
    sources := ["Penzias and Wilson 1965"] }

def excessSteady : Theory :=
  { statement := "The excess temperature is, within the limits of the observations, free from seasonal variations (July 1964 to April 1965), and had not changed during almost a year."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def surveyMin : Theory :=
  { statement := "The minimum temperature of the sky background measured at 404 Mc/s by Pauliny-Toth and Shakeshaft (1962) was 16 K."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def sameAt3cm : Theory :=
  { statement := "In December 1965 Roll and Wilkinson completed their measurement of 3.0 ± 0.5 K at 3.2 cm, the first confirming microwave measurement."
    sources := ["Wilson 1978"] }

def cnTemp : Theory :=
  { statement := "McKellar, using Adams' data on the populations of the two states, calculated that the excitation temperature of CN was 2.3 K."
    sources := ["Wilson 1978"] }

/-! ## Claims that follow from the records -/

def ohmicTemp : Theory :=
  { statement := "The contribution to the antenna temperature from ohmic losses is computed to be 0.8 ± 0.4 K."
    sources := ["Penzias and Wilson 1965"] }

def backlobeTemp : Theory :=
  { statement := "The backlobe response to ground radiation is taken to be less than 0.1 K."
    sources := ["Penzias and Wilson 1965"] }

def excessTemp : Theory :=
  { statement := "The remaining unaccounted-for antenna temperature at 4080 Mc/s is 3.5 K, with a maximum measurement error of 1 K, considerably smaller than the measured value."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def spectrumFlat : Theory :=
  { statement := "Combining the minimum of 16 K at 404 Mc/s with the excess at 4080 Mc/s, the average spectrum of the background radiation over this frequency range is no steeper than 0.7, over a range of wavelengths that varied by a factor of 10."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def expectedNull : Theory :=
  { statement := "A background measurement at 7 cm should produce a null result, because the brightness temperature of the halo of the galaxy was expected to be less than 0.1 K at 7 cm."
    sources := ["Wilson 1978"] }

/-! ## Experiments -/

def antennaRun : Experiment :=
  { protocol := "The 20-foot horn-reflector antenna at Holmdel and a liquid-helium-cooled reference termination were connected in turn to a radiometer with a traveling-wave maser, by switching manually, and the effective zenith noise temperature was measured at 4080 Mc/s."
    observation := "The total antenna temperature measured at the zenith is 6.7 K."
    sources := ["Penzias and Wilson 1965"] }

def elevationScan : Experiment :=
  { protocol := "The antenna temperature at 7.35 cm wavelength was recorded as the antenna scanned from almost the zenith down to above the horizon."
    observation := "The variation in antenna temperature with elevation angle was recorded, scanning from almost the zenith down to above the horizon."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def antennaChecks : Experiment :=
  { protocol := "All the seams in the section near the throat and most of the others were taped with aluminum tape, the throat section was taken apart and checked, and the pigeons roosting in the horn were evicted and their mess cleaned up."
    observation := "Taping all the seams in the section near the throat and most of the others with aluminum tape caused no observable change in antenna temperature. We evicted the pigeons and cleaned up their mess, but obtained only a small reduction in antenna temperature."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def groundChecks : Experiment :=
  { protocol := "A small transmitter was put in each of ten locations on the ground near the antenna, pointed to the zenith, with complete rotations in azimuth, and the antenna was pointed to New York City and to other directions on the horizon."
    observation := "The average back-lobe level is more than 30 db below isotropic response. The antenna temperature never went significantly above the thermal temperature of the earth."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def yearRun : Experiment :=
  { protocol := "The excess antenna temperature was measured in different directions and polarizations from July 1964 to April 1965."
    observation := "This excess temperature is, within the limits of our observations, isotropic, unpolarized, and free from seasonal variations (July, 1964-April, 1965)."
    sources := ["Penzias and Wilson 1965"] }

def surveyRun : Experiment :=
  { protocol := "A 74 cm survey of the northern sky was made at Cambridge by Pauliny-Toth and Shakeshaft (1962), at 404 Mc/s."
    observation := "The minimum temperature on their map was 16 K."
    sources := ["Penzias and Wilson 1965", "Wilson 1978"] }

def confirmRun : Experiment :=
  { protocol := "Roll and Wilkinson measured the background radiation at 3.2 cm wavelength with a radiometer and receiving horn."
    observation := "In December 1965 Roll and Wilkinson completed their measurement of 3.0 ± 0.5 K at 3.2 cm."
    sources := ["Wilson 1978", "Dicke, Peebles, Roll and Wilkinson 1965"] }

def cnAbsorption : Experiment :=
  { protocol := "Adams and Dunham observed optical interstellar absorption lines of the molecules CH, CH+ and CN, between 1937 and 1943."
    observation := "In the case of CN, in addition to the ground state, absorption was seen from the first rotationally excited state, and McKellar's calculation from the populations of the two states gave an excitation temperature of 2.3 K."
    sources := ["Wilson 1978"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- the record and its readings
        Edge.interprets totalTemp antennaRun
      , Edge.interprets atmosphereTemp elevationScan
      , Edge.interprets antennaChecksNull antennaChecks
      , Edge.interprets groundQuiet groundChecks
      , Edge.interprets excessIsotropic yearRun
      , Edge.interprets excessSteady yearRun
      , Edge.interprets surveyMin surveyRun
      , Edge.interprets sameAt3cm confirmRun
      , Edge.interprets cnTemp cnAbsorption
        -- the subtraction of the known contributions
      , Edge.implies groundQuiet backlobeTemp
          "A back-lobe level more than 30 db below isotropic response leaves less than 0.1 K from the ground."
      , Edge.entails [totalTemp, atmosphereTemp, ohmicTemp, backlobeTemp, coldLoadCalibrated] excessTemp
          "The total of 6.7 K less the atmosphere (2.3 K), the ohmic loss (0.8 K) and the back lobes (under 0.1 K) leaves 3.5 K; the total rests on the calibration of the reference termination."
      , Edge.contradicts expectedNull excessTemp
          "A null result at 7 cm is not an excess of 3.5 K."
      , Edge.entails [excessTemp, surveyMin] spectrumFlat
          "The excess at 4080 Mc/s and the minimum of 16 K at 404 Mc/s give a spectrum no steeper than 0.7 over a factor of 10 in wavelength."
        -- the systematics, each forbidding one reading
      , Edge.nogood [antennaLossCause, antennaChecksNull]
          "If losses in the horn caused the excess, taping the seams and removing the pigeons would have lowered it."
      , Edge.nogood [groundPickupCause, groundQuiet]
          "If the ground or man-made noise caused the excess, the antenna would have heard the ground through its back lobes or in the direction of the city."
      , Edge.nogood [knownSourcesCause, excessIsotropic]
          "A contribution of the galaxy or of discrete sources would vary with position."
      , Edge.nogood [knownSourcesCause, spectrumFlat]
          "Radio sources of types known to exist have a much steeper spectrum."
      , Edge.nogood [solarOrBeltsCause, excessSteady]
          "A source in the solar system would change as the earth moves, and radiation from the belts would have decayed after a year."
      , Edge.nogood [atmosphereDoubled, atmosphereTemp]
          "An atmosphere twice as absorbing is not what the elevation scan shows."
        -- the reading of the Princeton group
      , Edge.implies relicRadiation excessIsotropic
          "A relic radiation of the early universe has a single temperature, the same in all directions."
      , Edge.implies relicRadiation excessSteady
          "A relic radiation of the early universe does not change with the seasons."
      , Edge.implies relicRadiation spectrumFlat
          "A black-body radiation of one temperature has the same temperature at every wavelength."
      , Edge.implies relicRadiation sameAt3cm
          "A black-body radiation of one temperature gives the same temperature at 3.2 cm as at 7.35 cm."
      , Edge.entails [relicRadiation, noOtherCnExcitation] cnTemp
          "With no other source of excitation, the CN molecules are excited by the relic radiation to its temperature."
      , Edge.contradicts steadyState relicRadiation
          "A universe that has been expanding with continuous creation has no extremely hot early stage to leave a relic."
      ] }

/-- Named checks; the verifier mutates the graph and runs these on every mutant. -/
def checks (g : Graph) : List (String × Bool) :=
  [ ("graph is well formed", g.wellFormed)
    -- readings
  , ("antenna reading", g.readings.contains (totalTemp, antennaRun))
  , ("elevation reading", g.readings.contains (atmosphereTemp, elevationScan))
  , ("antenna checks reading", g.readings.contains (antennaChecksNull, antennaChecks))
  , ("ground checks reading", g.readings.contains (groundQuiet, groundChecks))
  , ("isotropy reading", g.readings.contains (excessIsotropic, yearRun))
  , ("steadiness reading", g.readings.contains (excessSteady, yearRun))
  , ("survey reading", g.readings.contains (surveyMin, surveyRun))
  , ("confirmation reading", g.readings.contains (sameAt3cm, confirmRun))
  , ("CN reading", g.readings.contains (cnTemp, cnAbsorption))
    -- the subtraction needs every term
  , ("the excess follows from the five terms",
      (g.derive [totalTemp, atmosphereTemp, ohmicTemp, backlobeTemp, coldLoadCalibrated]).contains excessTemp)
  , ("the excess needs the total",
      !(g.derive [atmosphereTemp, ohmicTemp, backlobeTemp, coldLoadCalibrated]).contains excessTemp)
  , ("the excess needs the atmosphere",
      !(g.derive [totalTemp, ohmicTemp, backlobeTemp, coldLoadCalibrated]).contains excessTemp)
  , ("the excess needs the ohmic loss",
      !(g.derive [totalTemp, atmosphereTemp, backlobeTemp, coldLoadCalibrated]).contains excessTemp)
  , ("the excess needs the back lobes",
      !(g.derive [totalTemp, atmosphereTemp, ohmicTemp, coldLoadCalibrated]).contains excessTemp)
  , ("the excess needs the calibration of the reference termination",
      !(g.derive [totalTemp, atmosphereTemp, ohmicTemp, backlobeTemp]).contains excessTemp)
  , ("the ground check gives the back-lobe term", (g.derive [groundQuiet]).contains backlobeTemp)
  , ("the excess is a surprise", g.exclusive expectedNull excessTemp)
  , ("the surprise needs the whole subtraction",
      g.inconsistent [expectedNull, totalTemp, atmosphereTemp, ohmicTemp, backlobeTemp, coldLoadCalibrated])
  , ("the null expectation alone is consistent", !g.inconsistent [expectedNull])
    -- the spectrum
  , ("the spectrum follows from the excess and the survey", (g.derive [excessTemp, surveyMin]).contains spectrumFlat)
  , ("the spectrum needs the excess", !(g.derive [surveyMin]).contains spectrumFlat)
  , ("the spectrum needs the survey", !(g.derive [excessTemp]).contains spectrumFlat)
    -- the systematics are ruled out one by one
  , ("antenna losses are refuted by the checks", g.refutes [antennaLossCause] antennaChecks)
  , ("ground pickup is refuted by the ground checks", g.refutes [groundPickupCause] groundChecks)
  , ("known sources are refuted by the isotropy", g.refutes [knownSourcesCause] yearRun)
  , ("known sources are refuted by the survey", g.refutes [knownSourcesCause, excessTemp] surveyRun)
  , ("known sources are not refuted without the survey", !g.refutes [knownSourcesCause] surveyRun)
  , ("a solar-system source is refuted by the year of data", g.refutes [solarOrBeltsCause] yearRun)
  , ("a doubled atmosphere is refuted by the elevation scan", g.refutes [atmosphereDoubled] elevationScan)
  , ("antenna losses survive the ground checks", !g.refutes [antennaLossCause] groundChecks)
  , ("ground pickup survives the antenna checks", !g.refutes [groundPickupCause] antennaChecks)
  , ("a solar-system source survives the antenna checks", !g.refutes [solarOrBeltsCause] antennaChecks)
  , ("each cause alone is consistent",
      !g.inconsistent [antennaLossCause] && !g.inconsistent [groundPickupCause] && !g.inconsistent [knownSourcesCause]
        && !g.inconsistent [solarOrBeltsCause] && !g.inconsistent [atmosphereDoubled])
    -- the reading of the Princeton group
  , ("the relic radiation is not refuted by the isotropy", !g.refutes [relicRadiation] yearRun)
  , ("the relic radiation is not refuted by the antenna checks", !g.refutes [relicRadiation] antennaChecks)
  , ("the relic radiation is not refuted by the ground checks", !g.refutes [relicRadiation] groundChecks)
  , ("the relic radiation is not refuted by the survey", !g.refutes [relicRadiation, excessTemp] surveyRun)
  , ("the relic radiation is not refuted by the elevation scan", !g.refutes [relicRadiation] elevationScan)
  , ("the relic radiation is isotropic", (g.derive [relicRadiation]).contains excessIsotropic)
  , ("the relic radiation is steady", (g.derive [relicRadiation]).contains excessSteady)
  , ("the relic radiation has a flat spectrum", (g.derive [relicRadiation]).contains spectrumFlat)
  , ("the relic radiation explains the isotropy and steadiness", g.supports [relicRadiation] yearRun)
  , ("the relic radiation explains the 3.2 cm measurement", g.supports [relicRadiation] confirmRun)
  , ("the relic radiation explains the CN temperature", g.supports [relicRadiation, noOtherCnExcitation] cnAbsorption)
  , ("the CN temperature needs the relic radiation", !g.supports [noOtherCnExcitation] cnAbsorption)
  , ("the CN temperature needs the absence of other excitation", !g.supports [relicRadiation] cnAbsorption)
  , ("the relic radiation does not explain the antenna total", !g.supports [relicRadiation] antennaRun)
  , ("the relic radiation does not give the excess", !(g.derive [relicRadiation]).contains excessTemp)
  , ("the relic radiation is consistent with the whole record",
      !g.inconsistent [relicRadiation, totalTemp, atmosphereTemp, ohmicTemp, backlobeTemp, coldLoadCalibrated,
        excessTemp, excessIsotropic, excessSteady, surveyMin, spectrumFlat, sameAt3cm, cnTemp, noOtherCnExcitation])
    -- the steady-state assumption
  , ("the steady state excludes the relic radiation", g.exclusive steadyState relicRadiation)
  , ("the steady state does not explain the isotropy", !g.supports [steadyState] yearRun)
  , ("the steady state does not explain the 3.2 cm measurement", !g.supports [steadyState] confirmRun)
  , ("the steady state does not explain the CN temperature", !g.supports [steadyState, noOtherCnExcitation] cnAbsorption)
  , ("the steady state alone is consistent", !g.inconsistent [steadyState])
  ]

#guard (checks evidenceGraph).all (·.2)

end Scilib.PenziasWilsonHolmdel
