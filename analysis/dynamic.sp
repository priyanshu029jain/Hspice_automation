* Analysis - Dynamic Power
VIN IN VSS PULSE('VSS_VAL' 'VDD_VAL' 0n 50p 50p 5n 10n)

.tran 10p 50n

* Print transient supply current
.print tran I(VDD)



