* schematic/pseudo_pmos.sp - PMOS Driver + Resistor Pull-Down

.PARAM VDD_VAL = 1.0
.PARAM VSS_VAL = 0.0
.PARAM R_LOAD = 10k
.PARAM W_pmos = 130N
.PARAM Cload = 1ff
.PARAM L_mos = 65N

* Include Process Model File
.INCLUDE '../65nm.pm'

* Power Supply Sources (Referenced to global 0)
V_VDD VDD 0 DC 'VDD_VAL'
V_VSS VSS 0 DC 'VSS_VAL'

* Active PMOS Driver
MP1 OUT IN VDD VDD PMOS L=L_mos W=W_pmos

* Load capacitance
Cout OUT VSS Cload

* Resistor Pull-Down (Connected to VSS)
R_PULLDOWN OUT VSS 'R_LOAD'