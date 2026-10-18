* schematic/pseudo_nmos.sp - NMOS Driver + Resistor Pull-Up

.PARAM VDD_VAL = 1.0
.PARAM VSS_VAL = 0.0
.PARAM R_LOAD = 10k
.PARAM W_nmos = 65N
.PARAM Cload = 1ff
.PARAM L_mos = 65N

* Include Process Model File
.INCLUDE '65nm.pm'

* Power Supply Sources (Referenced to global 0)
V_VDD VDD 0 DC 'VDD_VAL'
V_VSS VSS 0 DC 'VSS_VAL'

* Resistor Pull-Up
R_PULLUP VDD OUT 'R_LOAD'

* Load capacitance
Cout OUT VSS Cload

* Active NMOS Driver (Source & Bulk connected to VSS)
MN1 OUT IN VSS VSS NMOS L=L_mos W=W_nmos