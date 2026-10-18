* Analysis - Transient Response
VIN IN VSS PWl(0n 'VSS_VAL' 24n 'VSS_VAL' 26n 'VDD_VAL' 74n 'VDD_VAL' 76n 'VSS_VAL' 100n 'VSS_VAL')

.tran 10p 100n 

* Print input/output voltages and supply current to output file
.print tran V(IN) V(OUT) I(VDD)
.plot tran V(IN) V(OUT)

