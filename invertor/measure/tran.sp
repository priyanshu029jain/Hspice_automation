* ==============================================================================
* Industry-Standard Transient Timing & Slew Measurements
* ==============================================================================

* 1. Propagation Delays (50% VDD thresholds)
.MEASURE TRAN t_phl 
+ TRIG V(IN)  VAL='VDD_VAL*0.5' RISE=1 
+ TARG V(OUT) VAL='VDD_VAL*0.5' FALL=1

.MEASURE TRAN t_plh 
+ TRIG V(IN)  VAL='VDD_VAL*0.5' FALL=1 
+ TARG V(OUT) VAL='VDD_VAL*0.5' RISE=1

* Average Propagation Delay
.MEASURE TRAN t_pd PARAM='(t_phl + t_plh) / 2'

* Delay Skew |t_phl - t_plh|
.MEASURE TRAN t_skew PARAM='abs(t_phl - t_plh)'

* 2. Output Slew Rates (20% to 80% VDD thresholds)
.MEASURE TRAN fall_time 
+ TRIG V(OUT) VAL='VDD_VAL*0.9' FALL=1 
+ TARG V(OUT) VAL='VDD_VAL*0.1' FALL=1

.MEASURE TRAN rise_time 
+ TRIG V(OUT) VAL='VDD_VAL*0.1' RISE=1 
+ TARG V(OUT) VAL='VDD_VAL*0.9' RISE=1