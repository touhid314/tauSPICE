clear;

%% input netlist
% netlist is an array of string arrays not char arrays

% some elements transient property hasn't been added yet. might give
% unexpected result.

%sadiku ex 3.2
nl = ["I1 0 1 DC 3";
    "Vd 1 4 DC 0";
    "R1 4 2 2";
    "R2 1 3 4";
    "R3 2 0 4";
    "R4 2 3 8";
    "F1 3 0 Vd 2";
    ".SSA"];



%% parse input netlist to make a cell array of element objects
[elements, queries] = nlparser(nl);

%% handle queries
ana_type = queries{1}{1}; %THIS PART NEEDS TO BE CHANGED LATER

if ana_type == "SSA"
    analy = {ana_type};
elseif ana_type == "TRA"
    start = queries{1}{2};
    stop = queries{1}{3};
    step = queries{1}{4};
    
    analy = {ana_type start stop step};
end

[sol, vars_index] = solver(elements, analy);

disp("Solution Matrix: ");
disp(sol);
disp("Node Index: ");
disp(vars_index);

