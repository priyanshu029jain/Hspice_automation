* ==============================================================================
* Schematic: nand
* Auto-generated CLI Characterization Template
* ==============================================================================
*
* ------------------------------------------------------------------------------
* HSPICE COMPONENT SYNTAX CHEAT SHEET
* ------------------------------------------------------------------------------
*  MOSFET:     M<name> Drain Gate Source Body ModelName L=val W=val
*              Example: M1 OUT IN VSS VSS NMOS L='L_mos' W='W_nmos'
*
*  RESISTOR:   R<name> Node1 Node2 Value
*              Example: R1 OUT VSS 10K
*
*  CAPACITOR:  C<name> Node1 Node2 Value
*              Example: C1 OUT VSS 1FF
*
*  INDUCTOR:   L<name> Node1 Node2 Value
*              Example: L1 IN1 IN2 1N
*
*  DC SOURCE:  V<name> Node(+) Node(-) DC Value
*              Example: VVDD VDD 0 DC 1.0
*
*  PULSE SRC:  V<name> N(+) N(-) PULSE(V1 V2 Delay Rise Fall Width Period)
*              Example: VIN IN 0 PULSE(0 1.0 0p 10p 10p 500p 1000p)
*
*  SUBCIRCUIT: X<name> Node1 Node2 ... NodeN SubcktName
*              Example: XINV1 VDD VSS IN OUT CMOS_INVERTER
* ------------------------------------------------------------------------------

* Process & Global Parameters
.PARAM VDD_VAL = 1.0
.PARAM VSS_VAL = 0.0
.PARAM W_pmos  = 130N
.PARAM W_nmos  = 65N
.PARAM L_mos   = 65N
.PARAM Cload   = 1ff
.PARAM R_LOAD  = 10K

* Include Process Model File
.INCLUDE '65nm.pm'

* Independent Power Supply Sources
V_VDD VDD 0 DC 'VDD_VAL'
V_VSS VSS 0 DC 'VSS_VAL'

* Output Load Capacitance
Cout OUT VSS 'Cload'

* --- Transistor Netlist / Devices ---
* 2-input NAND: OUT = NOT(A AND B)
*   Input A = IN   (driven by the analysis/*.sp stimulus)
*   Input B = IN_B (held at VDD, the non-controlling value, so OUT responds to A)
V_INB IN_B 0 DC 'VDD_VAL'

* Pull-up network: two PMOS in parallel
MPA OUT IN   VDD VDD PMOS L='L_mos' W='W_pmos'
MPB OUT IN_B VDD VDD PMOS L='L_mos' W='W_pmos'

* Pull-down network: two NMOS in series (2x width to match the inverter pull-down)
MNA OUT IN   N1  VSS NMOS L='L_mos' W='2*W_nmos'
MNB N1  IN_B VSS VSS NMOS L='L_mos' W='2*W_nmos'

.END
