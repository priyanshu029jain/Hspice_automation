* schematic/buffer_pmos.sp - PMOS Source Follower (Common Drain)

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

* Load Resistor Pull-Up (VDD to OUT)
R_LOAD VDD OUT 'R_LOAD'

* Active PMOS Driver: Drain=VSS, Gate=IN, Source=OUT, Bulk=VDD
MP1 VSS IN OUT VDD PMOS L=L_mos W=W_pmos

* Load Capacitance
Cout OUT VSS Cload