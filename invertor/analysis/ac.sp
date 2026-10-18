* Analysis - AC Frequency Response

*name  +ve_terminal  -ve_terminal   dc_vaule   ac_value
VIN       IN            VSS          DC 0.5V    AC 1V

*sweeps 20points per decade from 1KHz to 100 GHz
.ac dec 10 1k 100G

* Print AC magnitude (dB) and phase of output voltage
.print ac vm(OUT) vdb(OUT) vp(OUT)
.plot ac vdb(OUT)