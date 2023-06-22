clear;

%% input netlist
% netlist is an array of string arrays not char arrays

%circuit with short circuit
nl = ["V1 1 0 DC 5";
    "R1 1 2 1000";
    "R2 2 3 1000";
    "R3 3 4 1000";
    "R4 4 0 1000";
    "S1 1 3";
    "S2 2 4"];


%% analysis starts
%Goal is to create the conductance matrix G and the rhs 

%% parse input netlist to make a cell array of element objects
elements = nlparser(nl);

%% determining total number of variables

% determining total number of nodes
tot_el = length(elements);

tot_node = 0;
for i=1:tot_el
    t = max(elements{i}.nodes);
    if t>tot_node
        tot_node = t;
    end
end

% creating a cell array table for holding variables to be solved
for i=0:tot_node
    vars_index{i + 1,1} = i; % variables index
end

% determining current variables to be calculated as variable
% each VDC, VCVS(E) adds 1 extra variable
% each CCVS(H) adds 1 extra variables
count = tot_node + 1;
for i=1:tot_el
    
    ext_var = elements{i}.extra_var; %ext_var holds the extra variable array
    has_ext_var = ext_var(1);
    
    if has_ext_var == true      
        
        n = ext_var(2); %no of extra variables the element add
        
        for j = 1:n
            % this loop adds in the vars_index all the extra variable of the element 
            count = count + 1;
            vars_index{count, 1} = ext_var((2*j + 1): (2*j +2));
        end      
    end
end

% total number of variables
tot_vars = length(vars_index);

%% initialize the conductance matrix and the rhs with zeros
G  = zeros(tot_vars, tot_vars);
rhs = zeros(tot_vars, 1);


%% perform stamping for each element
for i = 1:tot_el
    [G, rhs] = elements{i}.stamper(G,vars_index, rhs);
end

%% determining node voltages

%deleting first row and first column of G and first row of rhs. 
% this is because v0 = 0;
G(1,:) = [];
G(:,1) = [];

rhs(1) = [];

%solving 

vars = gajopi(G,rhs); %using gauss jordan elimination method with pivoting
disp(vars);

