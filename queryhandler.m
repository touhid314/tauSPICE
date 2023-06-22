clear;

%% input netlist
% netlist is an array of string arrays not char arrays


%sadiku ex 8.10 page 341
%sadiku ex 8.10 page 341
% sadiku ex 10.1 PAGE 414
nl = ["Vac 1 0 SIN 20 0.6366 0";
    "R1 1 2 10";
    "C1 4 0 0.1";
    "Vd 2 4 DC 0";
    "L1 2 3 1";
    "F1 0 3 Vd 2";
    "L1 0 3 0.5";
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

disp(sol);
disp(vars_index);

