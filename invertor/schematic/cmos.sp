* CMOS Inverter Netlist
.PARAM VDD_VAL = 1.0
.PARAM VSS_VAL = 0.0
.PARAM W_pmos = 130N
.PARAM W_nmos = 65N
.PARAM Cload = 1ff
.PARAM L_mos = 65N

* Include Process Model File
.INCLUDE '../65nm.pm'

* Independent Power Supply Sources (Referenced to GND / 0)
V_VDD VDD 0 DC 'VDD_VAL'
V_VSS VSS 0 DC 'VSS_VAL'

* Load capacitance
Cout OUT VSS Cload

* CMOS Inverter Transistors
MP1 OUT IN VDD VDD PMOS L=L_mos W=W_pmos
MN1 OUT IN VSS VSS NMOS L=L_mos W=W_nmos