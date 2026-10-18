* ==============================================================================
* DC Voltage Transfer Characteristic (VTC) & Noise Margin Measurements
* ==============================================================================

* 1. Logic Extremes
.MEASURE DC v_oh MAX V(OUT)
.MEASURE DC v_ol MIN V(OUT)

* 2. Switching Threshold Vm where V(IN) == V(OUT)
.MEASURE DC v_m WHEN V(IN)=V(OUT)

* 3. Unity-Gain Voltage Points (Slope d(VOUT)/d(VIN) = -1)
.MEASURE DC v_il WHEN DERIV('V(OUT)')=-1 CROSS=1
.MEASURE DC v_ih WHEN DERIV('V(OUT)')=-1 CROSS=2

* 4. Static Noise Margins
.MEASURE DC nm_l PARAM='v_il - v_ol'
.MEASURE DC nm_h PARAM='v_oh - v_ih'