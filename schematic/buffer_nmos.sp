* schematic/buffer_nmos.sp - NMOS Source Follower (Common Drain)

.PARAM VDD_VAL = 1.0
.PARAM VSS_VAL = 0.0
.PARAM R_LOAD = 10k
.PARAM W_nmos = 130N
.PARAM Cload = 1ff
.PARAM L_mos = 65N

* Include Process Model File
.INCLUDE '65nm.pm'

* Power Supply Sources (Referenced to global 0)
V_VDD VDD 0 DC 'VDD_VAL'
V_VSS VSS 0 DC 'VSS_VAL'

* Active NMOS Driver: Drain=VDD, Gate=IN, Source=OUT, Bulk=VSS
MN1 VDD IN OUT VSS NMOS L=L_mos W=W_nmos

* Load Resistor Pull-Down (OUT to VSS)
R_LOAD OUT VSS 'R_LOAD'

* Load Capacitance
Cout OUT VSS Cload