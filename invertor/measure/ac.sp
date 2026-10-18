* ==============================================================================
* AC Frequency Response & Bandwidth Measurements
* ==============================================================================

* 1. Low Frequency Gain (dB)
.MEASURE AC dc_gain MAX vdb(OUT)

* 2. 3dB Cutoff Bandwidth Frequency
.MEASURE AC bandwidth_3db WHEN vdb(OUT)='dc_gain - 3' FALL=1

* 3. Unity Gain Frequency (0 dB Crossover)
.MEASURE AC f_unity WHEN vdb(OUT)=0 FALL=1

* 4. Phase at 3dB Cutoff
.MEASURE AC phase_at_3db FIND vp(OUT) AT='bandwidth_3db'