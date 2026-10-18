* ==============================================================================
* Static Leakage & Standby Power Measurements
* ==============================================================================

* 1. Leakage Current at IN = 0V
.MEASURE DC i_leak_low FIND I(VDD) AT='VSS_VAL'

* 2. Leakage Current at IN = VDD
.MEASURE DC i_leak_high FIND I(VDD) AT='VDD_VAL'

* 3. Worst-Case Static Leakage Power
.MEASURE DC i_leak_max MAX I(VDD)
.MEASURE DC p_static_max PARAM='abs(i_leak_max * VDD_VAL)'

*4. Avgrage leakage power
.measure dc P_static_in_low PARAM='abs(i_leak_low * VDD_VAL)'
.measure dc P_static_in_high PARAM='abs(i_leak_high * VDD_VAL)'
.measure dc P_static_avg PARAM='(P_static_in_low + P_static_in_high) / 2'
