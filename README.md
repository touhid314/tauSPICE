# tauSPICE
A SPICE based circuit simulator made with Matlab.

# Description
tauSPICE can perform both Steady state and tranient analysis. Currently the library has the following components:
* Capacitor (C)
* Current controlled current source (F)
* Current controlled voltage source (H)
* DC current source (IDC)
* Sinusoidal current source (ISIN)
* Inductor (L)
* Resistor (R)
* Short circuit (SC)
* Switch (UTCLOSE)
* Voltage controlled current source (G)
* Voltage controlled voltage source (E)
* DC voltage source (VDC)
* Sinusoidal voltage source (VSIN)

The library can be extended to have more elements by adding more elements in the lib folder.

# Example Circuits
Circuit:

<img src="/img/8.10/sadiku 4th ed example 8.10 page 341.png"/>

Equation of Vo: <img src="img/8.10/txtbook solution 8.10.png"/> 

Netlist input:
   ["V1 1 0 DC 7";
    "R1 1 2 3";
    "L1 2 3 0.5";
    "R2 3 0 1";
    "L2 3 0 0.20";
    ".TRA 0 1.5 .01"]

Transient solution of the tauSPICE:
<img src="img/8.10/solution 8.10.png"/>

