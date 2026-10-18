* ==============================================================================
* Dynamic Power & Energy Measurements
* ==============================================================================

* 1. Average & Peak Dynamic Current
.MEASURE TRAN i_avg_dynamic AVG I(VDD) FROM=0n TO=50n
.MEASURE TRAN i_peak_dynamic MAX I(VDD)

* 2. Average Dynamic Power Consumption
.MEASURE TRAN p_dynamic PARAM='abs(i_avg_dynamic * VDD_VAL)'

* 3. Energy per Cycle / Power-Delay Product (PDP)
.MEASURE TRAN energy_per_cycle PARAM='p_dynamic * 50n'
.MEASURE TRAN pdp PARAM='p_dynamic * t_pd'