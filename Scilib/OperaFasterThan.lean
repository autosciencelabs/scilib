import Scilib.Basic

/-!
# OPERA faster-than-light neutrinos, 2011-12: which part of the chain is to blame?

Domain #3 (blame among auxiliaries).  Source facts and their verification:
`parth/sources/opera-faster-than-light-neutrinos-2011-12/` (ledger.json, REPORT.md).  Primary sources: the
OPERA paper (arXiv:1109.4897v4, the 2012 version that includes the corrections), the ICARUS timing paper
(arXiv:1203.3433) and Cohen and Glashow (arXiv:1109.6562).  Secondary source: Wikipedia, "Faster-than-light
neutrino anomaly".

Graph shape (as in `JohnSnowAnd.lean`):

* rivals: `relativity` (neutrinos travel at the speed of light) and `superluminal` (they outrun it), plus the
  two timing faults found later, `fibreFault` and `clockFault`;
* the prediction `chainPrediction` needs relativity *and* five auxiliaries of the timing chain (GPS link,
  baseline, fibre delay, Master Clock oscillator, proton waveform).  The early arrival refutes the whole
  bundle, not relativity alone; the two faults are what the later checks found;
* the checks that localise the blame: the fibre re-measurement and the OPERA-LVD cosmic muons find the fibre
  fault, the injected-signal test finds the clock fault; ICARUS, on the same beam but with its own LNGS
  fibre, sees light speed, so the parts ICARUS shares with OPERA (GPS link, baseline) are cleared;
* two more refutations of the superluminal rival need hidden assumptions of their own: Cohen and Glashow's
  pair emission needs `pairMechanism`, and the SN1987A limit needs `energyIndependent`.

Not modelled: the original bunched-beam reading (about 62 ns early, only one secondary source), the
MINOS, Borexino and LVD speed measurements of May-June 2012, the resignation of the OPERA leaders, and
the theoretical papers that tried to explain the anomaly.
-/

namespace Scilib.OperaFasterThan

/-! ## Rivals and faults -/

def relativity : Theory :=
  { statement := "Relativity: neutrinos travel at the speed of light, their rest mass making the relative deviation smaller than 10^-19, so any larger deviation would point to Lorentz invariance violation in the neutrino sector."
    sources := ["OPERA 2012"] }

def superluminal : Theory :=
  { statement := "Superluminal neutrinos: the muon neutrinos of the CERN beam travel from CERN to Gran Sasso at a speed exceeding that of light by about 25 parts per million, which would be Lorentz invariance violation in the neutrino sector."
    sources := ["Cohen and Glashow 2011", "OPERA 2012"] }

def fibreFault : Theory :=
  { statement := "Fibre fault: an optical cable to the OPERA Master Clock was not properly connected, adding about 73 ns of delay in the fibre, so that the neutrino time of flight was underestimated."
    sources := ["OPERA 2012", "Wikipedia, Faster-than-light neutrino anomaly"] }

def clockFault : Theory :=
  { statement := "Clock fault: the frequency of the Master Clock oscillator was 0.124 ppm larger than specified, so the event time stamp was overestimated by up to 74 ns, depending on the position inside the data-taking cycle."
    sources := ["OPERA 2012", "Wikipedia, Faster-than-light neutrino anomaly"] }

/-! ## Auxiliaries of the timing chain (status recorded in `sources`) -/

def gpsSync : Theory :=
  { statement := "The clocks at CERN and at OPERA were linked through GPS time-transfer systems that established a permanent time link at the 2 ns level, calibrated in 2008 by METAS and verified in 2011 by PTB."
    sources := ["OPERA 2012"] }

def baselineKnown : Theory :=
  { statement := "The 730 km CNGS baseline from CERN to the OPERA detector was measured by a geodesy campaign with a precision of 20 cm."
    sources := ["OPERA 2012"] }

def fibreDelayKnown : Theory :=
  { statement := "The delay in the 8.3 km optical fibre to the OPERA Master Clock was taken to stay at the value measured in 2006 and 2007 during the data taking."
    sources := ["status: discovered", "OPERA 2012", "Wikipedia, Faster-than-light neutrino anomaly"] }

def oscillatorInSpec : Theory :=
  { statement := "The OPERA Master Clock was disciplined by a Vectron oscillator with a very small Allan deviation, which keeps the local time during the data-taking cycle."
    sources := ["OPERA 2012"] }

def waveformPDF : Theory :=
  { statement := "The proton waveforms measured at CERN were used as the probability density function for the distribution of the neutrino arrival times within the two extractions."
    sources := ["status: declared", "OPERA 2012"] }

def icarusChain : Theory :=
  { statement := "The timing signal of ICARUS reaches the underground hall via 8 km optic fibres, with a delay accurately calibrated in December 2011 following a double path procedure very similar to the one devised by OPERA for its first calibration in 2006."
    sources := ["ICARUS 2012"] }

def pairMechanism : Theory :=
  { statement := "Superluminal neutrinos lose energy by producing photons and electron-positron pairs through Z0 mediated processes, analogous to Cherenkov radiation."
    sources := ["status: declared", "ICARUS 2012", "Cohen and Glashow 2011"] }

def energyIndependent : Theory :=
  { statement := "Any excess of the neutrino speed over the speed of light is the same for 10 MeV supernova neutrinos and for 17 GeV beam neutrinos."
    sources := ["status: suspected", "OPERA 2012"] }

/-! ## Predictions -/

def chainPrediction : Theory :=
  { statement := "If neutrinos travel at the speed of light and the timing chain is as calibrated, the neutrinos arrive when light would, within a few nanoseconds, and not earlier."
    sources := ["status: inference", "OPERA 2012"] }

def icarusEarly : Theory :=
  { statement := "If neutrinos outrun light, the neutrino events of ICARUS on the same beam arrive about 60 ns before light would, as in OPERA."
    sources := ["status: inference", "ICARUS 2012"] }

def pairLoss : Theory :=
  { statement := "Superluminal neutrinos of the CERN beam would lose energy by pair emission on the way, so that the beam is depleted of higher energy neutrinos and pairs appear in the ICARUS detector."
    sources := ["status: inference", "Cohen and Glashow 2011", "ICARUS 2012"] }

/-! ## Readings -/

def earlyMain : Theory :=
  { statement := "OPERA's 15223 neutrino events arrived about 60 ns earlier than light would have, with the delays and baseline originally adopted."
    sources := ["OPERA 2012", "Cohen and Glashow 2011", "ICARUS 2012"] }

def onTimeMain : Theory :=
  { statement := "After the instrumental corrections, the neutrino arrival time of the 15223 OPERA events is compatible within errors with the time computed for the speed of light."
    sources := ["OPERA 2012", "Wikipedia, Faster-than-light neutrino anomaly"] }

def onTimeBunched : Theory :=
  { statement := "In the bunched beam test the average of the time differences measured by the Target Tracker agrees with the main analysis and with the ICARUS result."
    sources := ["OPERA 2012"] }

def fibreLonger : Theory :=
  { statement := "In December 2011 the fibre delay was found 73.2 ns larger than the one determined in 2006 and 2007, because of an optical cable not properly connected."
    sources := ["OPERA 2012", "Wikipedia, Faster-than-light neutrino anomaly"] }

def oscFast : Theory :=
  { statement := "Events injected 1 ms apart showed time stamps overestimated by up to 74 ns, because the Master Clock oscillator frequency was 0.124 ppm larger than specified."
    sources := ["OPERA 2012"] }

def muonShift : Theory :=
  { statement := "The time difference between the muon recorded by OPERA and the same muon recorded by LVD showed two abrupt changes, one around August 2008 and the other in December 2011, the decrease in December 2011 being related to the proper reconnection of the optical fibre to the OPERA Master Clock, and stayed constant in between."
    sources := ["OPERA 2012", "Wikipedia, Faster-than-light neutrino anomaly"] }

def icarusOnTime : Theory :=
  { statement := "Based on the seven recorded neutrino events, the ICARUS result is compatible with a neutrino propagation velocity in agreement with the speed of light and incompatible with the result reported by the OPERA Collaboration."
    sources := ["ICARUS 2012"] }

def noPairs : Theory :=
  { statement := "ICARUS searched for superluminal Cherenkov-like pairs inside the fiducial volume of its detector and found no candidate event, setting a tight negative limit."
    sources := ["ICARUS 2012"] }

def snLimit : Theory :=
  { statement := "At the much lower energy of 10 MeV, the observation of (anti)neutrinos emitted by the SN1987A supernova set a stringent limit on any deviation of their speed from that of light."
    sources := ["OPERA 2012", "Wikipedia, Faster-than-light neutrino anomaly"] }

/-! ## Experiments -/

def mainRun : Experiment :=
  { protocol := "OPERA measured the arrival times of the muon neutrinos of the CERN beam at Gran Sasso, 730 km away, in 2009, 2010 and 2011 and compared them with the proton waveforms measured at CERN."
    observation := "15223 neutrino events were detected, and with the delays and baseline originally adopted they arrived about 60 ns earlier than light would have."
    sources := ["OPERA 2012", "Cohen and Glashow 2011"] }

def bunchedRun : Experiment :=
  { protocol := "From 22 October to 6 November 2011 the proton beam was set up on purpose as four bunches about 3 ns long separated by 524 ns, so that each neutrino event could be associated to its proton bunch."
    observation := "A total of 20 Target Tracker and 16 RPC events were retained."
    sources := ["OPERA 2012"] }

def fibreRecheck : Experiment :=
  { protocol := "Starting at the beginning of December 2011, the time delay in the 8.3 km optical fibre between the GPS 1PPS output and the OPERA Master Clock output was measured with the standard two-way technique."
    observation := "The delay was 73.2 ns larger than the one determined in 2006 and 2007, with a larger jitter; the difference was traced to an optical cable not properly connected, and with proper connections restored the delay and the jitter agreed with 2006 and 2007."
    sources := ["OPERA 2012"] }

def clockRecheck : Experiment :=
  { protocol := "During the 2011 winter shut down a signal equivalent to 100 photoelectrons was injected at the photomultiplier connector level through a calibrated extra path, and the time stamps of the generated events were recorded by the data acquisition as for neutrino data."
    observation := "The time delay between two consecutive events, separated by 1 ms, was 0.124 ns larger than expected, so that the event time stamp was overestimated by up to 74 ns, depending on the position inside the data-taking cycle; the Master Clock oscillator frequency was 0.124 ppm larger than specified."
    sources := ["OPERA 2012"] }

def lvdMuons : Experiment :=
  { protocol := "Single horizontal cosmic muons traverse first the OPERA detector and then, 160 m away, the LVD apparatus, so that any change in the timing chain of either experiment shows in their time difference; the data run from mid 2007 until March 2012."
    observation := "The time difference between the muon recorded by OPERA and the same muon recorded by LVD showed two abrupt changes, one around August 2008 and the other in December 2011, and stayed constant in between."
    sources := ["OPERA 2012"] }

def icarusRun : Experiment :=
  { protocol := "From October 21st to November 4th 2011 the CERN-SPS accelerator was operated in a new, lower intensity mode, and ICARUS could use the GPS-based timing system linking CERN and LNGS."
    observation := "The ICARUS T600 detector collected 7 beam-associated events, and their time of flight difference with the speed of light was analysed."
    sources := ["ICARUS 2012"] }

def icarusPairs : Experiment :=
  { protocol := "ICARUS searched inside the fiducial volume of its liquid argon detector for superluminal Cherenkov-like pairs in the same CNGS neutrino beam."
    observation := "No candidate event was found."
    sources := ["ICARUS 2012"] }

def supernova : Experiment :=
  { protocol := "Earlier neutrino speed results were used for comparison, among them that from the neutrinos emitted by the supernova SN1987A at about 10 MeV."
    observation := "Earlier neutrino speed results used for comparison: (anti)neutrinos emitted by the SN1987A supernova in the 10 MeV range were observed, which set a stringent limit."
    sources := ["OPERA 2012"] }

/-! ## The graph -/

def evidenceGraph : Graph :=
  { edges :=
      [ -- observations and their readings
        Edge.interprets earlyMain mainRun
      , Edge.interprets onTimeMain mainRun
      , Edge.interprets onTimeBunched bunchedRun
      , Edge.interprets fibreLonger fibreRecheck
      , Edge.interprets oscFast clockRecheck
      , Edge.interprets muonShift lvdMuons
      , Edge.interprets icarusOnTime icarusRun
      , Edge.interprets noPairs icarusPairs
      , Edge.interprets snLimit supernova
      -- the two rivals
      , Edge.contradicts relativity superluminal
          "Neutrinos cannot both travel at the speed of light and exceed it by 25 parts per million."
      -- relativity with the calibrated chain predicts no early arrival; the early arrival refutes the bundle
      , Edge.entails [relativity, gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec] chainPrediction
          "Inference by the graph author: at light speed over a known distance, with correct clocks and delays, the neutrinos arrive when light does."
      , Edge.nogood [chainPrediction, waveformPDF, earlyMain]
          "The fit of the arrival times to the proton waveforms gives 60 ns early, where the chain predicts none."
      -- superluminal neutrinos with the same chain would give the early arrival
      , Edge.entails [superluminal, gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec, waveformPDF] earlyMain
          "Neutrinos faster than light, with the chain as calibrated, arrive early by the observed amount."
      -- the faults found later explain it with relativity intact
      , Edge.nogood [fibreDelayKnown, fibreFault]
          "A fibre delay 73 ns longer than the one used cannot be the 2006 value."
      , Edge.nogood [oscillatorInSpec, clockFault]
          "An oscillator above its specified frequency is not at the specified frequency."
      , Edge.entails [fibreLonger, muonShift] fibreFault
          "The December measurement and the muon time difference, constant since August 2008, put the extra delay through the whole data taking."
      , Edge.implies oscFast clockFault
          "The injected-signal test shows time stamps overestimated by up to 74 ns from the oscillator offset."
      , Edge.entails [relativity, gpsSync, baselineKnown, fibreFault, clockFault, waveformPDF] onTimeMain
          "With both faults corrected the neutrinos arrive when light does."
      , Edge.entails [relativity, gpsSync, baselineKnown, fibreFault, clockFault] onTimeBunched
          "The bunched beam, which needs no waveform, agrees once the faults are corrected."
      -- ICARUS: same beam, shares the GPS link and the baseline, has its own LNGS fibre
      , Edge.entails [superluminal, gpsSync, baselineKnown, icarusChain] icarusEarly
          "Inference by the graph author: the same beam would outrun light at ICARUS as at OPERA."
      , Edge.nogood [icarusEarly, icarusOnTime]
          "ICARUS sees light speed, where the superluminal rival predicts 60 ns early."
      , Edge.entails [relativity, gpsSync, baselineKnown, icarusChain] icarusOnTime
          "Relativity with the ICARUS chain predicts arrival with light."
      -- Cohen and Glashow
      , Edge.entails [superluminal, pairMechanism] pairLoss
          "Superluminal neutrinos would radiate pairs and lose energy rapidly."
      , Edge.nogood [pairLoss, noPairs]
          "ICARUS finds no pairs in the same beam."
      -- SN1987A
      , Edge.nogood [superluminal, energyIndependent, snLimit]
          "A 25 parts per million excess at 10 MeV would be far above the supernova limit."
      ] }

/-! ## Checks: what `lake build` verifies -/

/-- Named checks; the verifier mutates the graph and runs these on every mutant. -/
def checks (g : Graph) : List (String × Bool) :=
  [ ("graph is well formed", g.wellFormed)
    -- readings
  , ("main run, early reading", g.readings.contains (earlyMain, mainRun))
  , ("main run, corrected reading", g.readings.contains (onTimeMain, mainRun))
  , ("bunched run reading", g.readings.contains (onTimeBunched, bunchedRun))
  , ("fibre re-measurement reading", g.readings.contains (fibreLonger, fibreRecheck))
  , ("clock test reading", g.readings.contains (oscFast, clockRecheck))
  , ("cosmic muon reading", g.readings.contains (muonShift, lvdMuons))
  , ("ICARUS reading", g.readings.contains (icarusOnTime, icarusRun))
  , ("ICARUS pair search reading", g.readings.contains (noPairs, icarusPairs))
  , ("supernova reading", g.readings.contains (snLimit, supernova))
    -- the rivals
  , ("relativity excludes superluminal neutrinos", g.exclusive relativity superluminal)
    -- the early arrival refutes relativity together with the whole chain
  , ("the main run refutes relativity with the chain",
      g.refutes [relativity, gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec, waveformPDF] mainRun)
  , ("blame: the main run needs relativity",
      !g.refutes [gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec, waveformPDF] mainRun)
  , ("blame: the main run needs the GPS link",
      !g.refutes [relativity, baselineKnown, fibreDelayKnown, oscillatorInSpec, waveformPDF] mainRun)
  , ("blame: the main run needs the baseline",
      !g.refutes [relativity, gpsSync, fibreDelayKnown, oscillatorInSpec, waveformPDF] mainRun)
  , ("blame: the main run needs the fibre delay",
      !g.refutes [relativity, gpsSync, baselineKnown, oscillatorInSpec, waveformPDF] mainRun)
  , ("blame: the main run needs the oscillator",
      !g.refutes [relativity, gpsSync, baselineKnown, fibreDelayKnown, waveformPDF] mainRun)
  , ("blame: the main run needs the proton waveform",
      !g.refutes [relativity, gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec] mainRun)
  , ("the chain prediction needs relativity",
      !(g.derive [gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec]).contains chainPrediction)
  , ("the chain prediction needs the fibre delay",
      !(g.derive [relativity, gpsSync, baselineKnown, oscillatorInSpec]).contains chainPrediction)
  , ("the chain prediction needs the oscillator",
      !(g.derive [relativity, gpsSync, baselineKnown, fibreDelayKnown]).contains chainPrediction)
  , ("the chain prediction alone is consistent",
      !g.inconsistent [relativity, gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec, waveformPDF])
    -- superluminal neutrinos with the same chain explain the early arrival
  , ("superluminal neutrinos explain the main run",
      g.supports [superluminal, gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec, waveformPDF] mainRun)
  , ("the early arrival needs superluminal neutrinos",
      !(g.derive [gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec, waveformPDF]).contains earlyMain)
  , ("the early arrival needs the fibre delay",
      !(g.derive [superluminal, gpsSync, baselineKnown, oscillatorInSpec, waveformPDF]).contains earlyMain)
  , ("the early arrival needs the proton waveform",
      !(g.derive [superluminal, gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec]).contains earlyMain)
  , ("the early arrival needs the GPS link",
      !(g.derive [superluminal, baselineKnown, fibreDelayKnown, oscillatorInSpec, waveformPDF]).contains earlyMain)
  , ("the early arrival needs the baseline",
      !(g.derive [superluminal, gpsSync, fibreDelayKnown, oscillatorInSpec, waveformPDF]).contains earlyMain)
  , ("the early arrival needs the oscillator",
      !(g.derive [superluminal, gpsSync, baselineKnown, fibreDelayKnown, waveformPDF]).contains earlyMain)
  , ("superluminal neutrinos survive the main run",
      !g.refutes [superluminal, gpsSync, baselineKnown, fibreDelayKnown, oscillatorInSpec, waveformPDF] mainRun)
    -- the two faults
  , ("the fibre fault contradicts the fibre delay used", g.inconsistent [fibreDelayKnown, fibreFault])
  , ("the clock fault contradicts the oscillator in spec", g.inconsistent [oscillatorInSpec, clockFault])
  , ("the two faults do not contradict each other", !g.inconsistent [fibreFault, clockFault])
  , ("the fibre fault does not touch the oscillator", !g.inconsistent [oscillatorInSpec, fibreFault])
  , ("the fibre re-measurement alone does not prove the fault for the whole run",
      !(g.derive [fibreLonger]).contains fibreFault)
  , ("the cosmic muons alone do not prove the fibre fault",
      !(g.derive [muonShift]).contains fibreFault)
  , ("the fibre re-measurement and the muons prove the fibre fault",
      (g.derive [fibreLonger, muonShift]).contains fibreFault)
  , ("the clock test proves the clock fault", (g.derive [oscFast]).contains clockFault)
    -- with the faults, relativity fits the data
  , ("relativity with the faults explains the main run",
      g.supports [relativity, gpsSync, baselineKnown, fibreFault, clockFault, waveformPDF] mainRun)
  , ("the corrected reading needs the fibre fault",
      !(g.derive [relativity, gpsSync, baselineKnown, clockFault, waveformPDF]).contains onTimeMain)
  , ("the corrected reading needs the clock fault",
      !(g.derive [relativity, gpsSync, baselineKnown, fibreFault, waveformPDF]).contains onTimeMain)
  , ("the corrected reading needs relativity",
      !(g.derive [gpsSync, baselineKnown, fibreFault, clockFault, waveformPDF]).contains onTimeMain)
  , ("the corrected reading needs the GPS link",
      !(g.derive [relativity, baselineKnown, fibreFault, clockFault, waveformPDF]).contains onTimeMain)
  , ("the corrected reading needs the baseline",
      !(g.derive [relativity, gpsSync, fibreFault, clockFault, waveformPDF]).contains onTimeMain)
  , ("the corrected reading needs the proton waveform",
      !(g.derive [relativity, gpsSync, baselineKnown, fibreFault, clockFault]).contains onTimeMain)
  , ("relativity with the faults survives the main run",
      !g.refutes [relativity, gpsSync, baselineKnown, fibreFault, clockFault, waveformPDF] mainRun)
  , ("relativity with the faults explains the bunched run",
      g.supports [relativity, gpsSync, baselineKnown, fibreFault, clockFault] bunchedRun)
  , ("the bunched run reading needs relativity",
      !(g.derive [gpsSync, baselineKnown, fibreFault, clockFault]).contains onTimeBunched)
  , ("the bunched run reading needs the GPS link",
      !(g.derive [relativity, baselineKnown, fibreFault, clockFault]).contains onTimeBunched)
  , ("the bunched run reading needs the baseline",
      !(g.derive [relativity, gpsSync, fibreFault, clockFault]).contains onTimeBunched)
  , ("the bunched run reading needs the fibre fault",
      !(g.derive [relativity, gpsSync, baselineKnown, clockFault]).contains onTimeBunched)
  , ("the bunched run reading needs the clock fault",
      !(g.derive [relativity, gpsSync, baselineKnown, fibreFault]).contains onTimeBunched)
  , ("the bunched run does not need the proton waveform",
      (g.derive [relativity, gpsSync, baselineKnown, fibreFault, clockFault]).contains onTimeBunched)
    -- ICARUS clears the parts it shares with OPERA
  , ("ICARUS refutes superluminal neutrinos",
      g.refutes [superluminal, gpsSync, baselineKnown, icarusChain] icarusRun)
  , ("blame: ICARUS needs the superluminal rival",
      !g.refutes [gpsSync, baselineKnown, icarusChain] icarusRun)
  , ("blame: ICARUS needs the GPS link",
      !g.refutes [superluminal, baselineKnown, icarusChain] icarusRun)
  , ("blame: ICARUS needs the baseline",
      !g.refutes [superluminal, gpsSync, icarusChain] icarusRun)
  , ("blame: ICARUS needs its own chain",
      !g.refutes [superluminal, gpsSync, baselineKnown] icarusRun)
  , ("ICARUS does not refute relativity",
      !g.refutes [relativity, gpsSync, baselineKnown, icarusChain] icarusRun)
  , ("relativity explains ICARUS", g.supports [relativity, gpsSync, baselineKnown, icarusChain] icarusRun)
  , ("the ICARUS reading needs the GPS link",
      !(g.derive [relativity, baselineKnown, icarusChain]).contains icarusOnTime)
  , ("the ICARUS reading needs the baseline",
      !(g.derive [relativity, gpsSync, icarusChain]).contains icarusOnTime)
  , ("the ICARUS reading needs its own chain",
      !(g.derive [relativity, gpsSync, baselineKnown]).contains icarusOnTime)
  , ("ICARUS does not touch the OPERA fibre, oscillator or waveform",
      !g.refutes [fibreDelayKnown, oscillatorInSpec, waveformPDF] icarusRun)
  , ("the ICARUS prediction needs the superluminal rival",
      !(g.derive [gpsSync, baselineKnown, icarusChain]).contains icarusEarly)
    -- Cohen and Glashow
  , ("pair loss refutes superluminal neutrinos", g.refutes [superluminal, pairMechanism] icarusPairs)
  , ("blame: pair loss needs the pair mechanism", !g.refutes [superluminal] icarusPairs)
  , ("blame: pair loss needs the superluminal rival", !g.refutes [pairMechanism] icarusPairs)
  , ("pair loss does not refute relativity", !g.refutes [relativity, pairMechanism] icarusPairs)
  , ("pair loss needs both premises", !(g.derive [superluminal]).contains pairLoss)
    -- SN1987A
  , ("the supernova limit refutes superluminal neutrinos",
      g.refutes [superluminal, energyIndependent] supernova)
  , ("blame: the supernova limit needs energy independence", !g.refutes [superluminal] supernova)
  , ("blame: the supernova limit needs the superluminal rival", !g.refutes [energyIndependent] supernova)
  , ("the supernova limit does not refute relativity", !g.refutes [relativity, energyIndependent] supernova)
  ]

#guard (checks evidenceGraph).all (·.2)

end Scilib.OperaFasterThan
