* ==============================================================================
* Noise Spectral Density Measurements
* ==============================================================================

* 1. Output Noise Density at 1 MHz
.MEASURE AC out_noise_1m FIND onoise AT=1Meg

* 2. Equivalent Input Noise Density at 1 MHz
.MEASURE AC in_noise_1m FIND inoise AT=1Meg

* 3. Peak Output Noise across Frequency Range
.MEASURE AC peak_onoise MAX onoise

*4. total out and in noise 
.measure ac total_out_noise INTEG onoise 
.measure ac total_in_noise  INTEG inoise

