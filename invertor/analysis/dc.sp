* Analysis - DC Sweep (VTC)

VIN IN VSS DC 0V

.dc VIN 'VSS_VAL' 'VDD_VAL' 0.01V

* Print VTC input and output values
.print dc V(IN) V(OUT)
.plot dc V(OUT)
