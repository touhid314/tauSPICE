% sadiku 5th ed

%AC transient
nl = ["V 1 0 SIN 141.42 159.15 15";
    "R1 1 2 10";
    "L1 2 0 0.01";
    ".TRA 0 .02 0.0001"];

%sadiku pp8.10
nl = ["V1 1 0 DC 20";
    "R1 1 2 1";
    "C1 2 0 0.5";
    "R2 2 3 1";
    "C2 3 0 0.333";
    ".TRA 0 1 0.1"]

%sadiku ex 8.10 page 341
nl = ["V1 1 0 DC 7";
    "R1 1 2 3";
    "L1 2 3 0.5";
    "R2 3 0 1";
    "L2 3 0 0.20";
    ".TRA 0 1.5 .01"];

%RL circuit
nl= ["V1 1 0 DC 5";
    "R1 1 2 10";
    "L1 2 0 6 3";
    ".TRA 0 3 0.1"];

%RC circuit with switch
nl = ["V1 1 0 DC 5";
    "R1 1 2 2000";
    "U1 2 3 TCLOSE 0";
    "C1 3 0 50e-6 2";
    ".TRA 0 .5 .025"];
% here tau = RC = 0.1

% RC circuit
nl = ["V1 1 0 DC 5";
    "R1 1 2 2000";
    "C1 2 0 50e-6 2";
    ".TRA 0 .5 .025"]
%here tau = RC = 0.1

% sadiku ex 10.13 p 433
nl = ["Vac 1 0 SIN 8 159.155 50";
    "R1 1 2 4000";
    "C1 4 0 2e-6";
    "L1 2 3 50e-3";
    "Vd 2 4 DC 0";
    "F1 0 3 Vd 0.5";
    "R1 0 3 2e3"];


% sadiku ex 10.1 PAGE 414
nl = ["Vac 1 0 SIN 20 0.6366 0";
    "R1 1 2 10";
    "C1 4 0 0.1";
    "Vd 2 4 DC 0";
    "L1 2 3 1";
    "F1 0 3 Vd 2";
    "L1 0 3 0.5";
    ".SSA"];

% sadiku ex9.9 p389
nl = ["V1 1 0 SIN 10 60 0";
    "R1 1 2 5";
    "C1 2 0 0.1";
    ".SSA"];

% dc circuit with capacitor
nl = ["V1 0 2 DC 5";
    "R1 0 2 10";
    "R2 0 1 20";
    "C1 1 2 0.0001";
    ".SSA"];

%a dc rc circuit
nl = ["V1 0 1 DC 10";
    "R1 0 2 1000";
    "C1 2 0 5"];

%circuit with short circuit
nl = ["V1 1 0 DC 5";
    "R1 1 2 1000";
    "R2 2 3 1000";
    "R3 3 4 1000";
    "R4 4 0 1000";
    "S1 1 3";
    "S2 2 4"];
% %ans, v1 through v4 
% 5.0000
%     3.7500
%     5.0000
%     3.7500


%sadiku pp 3.4 page 93
nl = ["R1 0 4 2";
    "R2 0 2 4";
    "R3 0 3 3";
    "R4 1 3 5";
    "V1 1 2 DC 25";
    "Vd 1 4 DC 0";
    "H1 3 2 Vd 5"];

%sadiku problem 3.16
nl = ["I1 0 1 DC 2";
    "R1 0 1 1";
    "R2 0 2 0.25";
    "R3 2 3 0.1250";
    "R4 1 3 0.5";
    "V1 3 0 DC 13";
    "E1 1 2 2 0 2"]

%sadiku pp 3.2
nl = ["I1 0 1 DC 4";
    "R1 1 2 3";
    "Vd 2 4 DC 0";
    "R2 4 0 4";
    "R3 1 3 2";
    "F1 3 2 Vd 4";
    "R4 3 0 6"];

%sadiku ex 3.2
nl = ["I1 0 1 DC 3";
    "Vd 1 4 DC 0";
    "R1 4 2 2";
    "R2 1 3 4";
    "R3 2 0 4";
    "R4 2 3 8";
    "F1 3 0 Vd 2"];

nl = ["I1 0 1 DC 3";
    "R1 0 1 2";
    "R2 1 2 6";
    "R3 2 0 7";
    "I2 2 0 DC 12";
    "V1 1 2 DC 5";
    "G 1 2 0 2 6";
    "V2 0 1 DC 5"];

%sadiku ex 3.1 page 84
nl = ["R1 0 1 2";...
"R2 1 2 4";...
"R3 2 0 6";...
"I1 2 1 DC 5";...
"I2 0 2 DC 10"];

%sadiku ex 3.3 pa90
nl = ["I1 0 1 DC 2";
    "R1 0 1 2";
    "R2 0 2 4";
    "I2 2 0 DC 7";
    "V1 2 1 DC 2";
    "R3 1 2 10"];