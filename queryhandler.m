clear;

%% input netlist
% netlist is an array of string arrays not char arrays


%sadiku ex 8.10 page 341
%sadiku ex 8.10 page 341
nl = ["V1 1 0 DC 7";
    "R1 1 2 3";
    "L1 2 3 0.5";
    "R2 3 0 1";
    "L2 3 0 0.20";
    ".TRA 0 1.5 .01"];

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

