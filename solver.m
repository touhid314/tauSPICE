function [sol, vars_index] = solver(elements, analy)
format long;
%SOLVER this function solves the circuit specified in the elements cell
%array and return the node voltage-extra variable array as output.
%   elements - is the cell array of circuit objects.
%   analysis_type - an array representing the analysis type.
%   [SSA] - for steady state analysis
%   [TRA start_time stop_time step] - for transient analysis
%   This funcion automatically determines whether the circuit is AC or DC
%   or time varying

analysis_type = analy{1};

%% determining analysis

% 4 available analysis
% 1 - DC SSA
% 2 - DC TRA
% 3 - AC SSA
% 4 - AC TRA

% determinig whether AC or DC
cir_types = ["DC", "AC", "TV"]; %TV is time varying. circuit is time varying
% if it has time varying sources like
%VPULSE etc.
cir_type = cir_types(1);

for i = 1:length(elements)
    el_type = elements{i}.type;
    if el_type == "VSIN"    %or ISIN
        cir_type = cir_types(2);
        
        val = elements{i}.value;
        ss_ac_freq = val(2); %steady state ac frequency
        
        break;
    end
end

if cir_type == "DC"
    if analysis_type == "SSA"
        analysis = 1; % 1 is dc ssa
    elseif analysis_type == "TRA"
        analysis = 2; % 2 is dc tra
    end
    
elseif cir_type == "AC"
    if analysis_type == "SSA"
        analysis = 3; % 1 is ac ssa
    elseif analysis_type == "TRA"
        analysis = 4; % 2 is ac tra
    end
end


%% determining total number of variables
[tot_vars, vars_index] = var_counter(elements, analysis);
tot_el = length(elements);

%% initialize the conductance matrix and the rhs with zeros
G  = zeros(tot_vars, tot_vars);
rhs = zeros(tot_vars, 1);
vars_index(1) = []; %trimming the first row because it holds v0 which is zero and is not in the solution array

%% perform stamping for each element

%analysis_type - WHETHER ITS SSA OR TRA
%analysis - A NUMBER THAT TELLS WHETHER IT IS DC SSA(1), DC TRA(2), AC SSA(3), AC TRA(4)
%ana - A CELL ARRAY THAT HOLDS ANALYSIS AND NECESSARY INFORMATION FOR THE ANALYSIS
%       {analysis, necessary_infos...}, {1}, {3 ss_freq}, {2 start stop step}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if analysis == 1 || analysis == 3
    % FOR AC DC STEADY STATE ANALYSIS
    
    % making the analysis array
    % ana = [1], [3 freq], [2 time_instance]
    
    if analysis == 3
        % ac ssa
        ana = {3 ss_ac_freq};
        
    elseif analysis == 1
        % dc ssa
        ana = {1};
    end
    
    % stamping
    for i = 1:tot_el
        [G, rhs] = elements{i}.stamper(G,vars_index, rhs, ana);
    end
    
    % solution
    sol = solvemat(G, rhs);
    return;
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
elseif analysis == 2
    % FOR DC TRANSIENT ANALYSIS
    
    %
    start = 0; %for transient analysis start has to be always 0;
    stop = analy{3};
    step = analy{4};
    %
    
    %INITIALISING tran_sols matrix
    no_of_sols = floor((stop - start)/step); % number of time instances we need to solve for
    tran_sols = cell(no_of_sols, 2); %initializing the tran sols cell array to hold all the transient solutions
    % format of tran_sols cell array: {timepoint, sol;
    %                                   timepoint,sol;
    %                                   .....
    %                                   .....};
 
    for i = 1:no_of_sols
        
        t = start + (i)*step; % current time instance we are solving for

        
        %PERFORMING TRANSIENT ANALYSIS
        ana = {2 start stop step};
        
        for j = 1:tot_el
            [G, rhs] = elements{j}.stamper(G,vars_index, rhs, ana);
        end
        
        %update memory of capacitor and inductor
        cir_sol = solvemat(G, rhs);
        
        for k = 1:tot_el
            if isprop(elements{k}, "mem_el")
                elements{k} = elements{k}.update_mem(cir_sol, vars_index);
            end
        end
        
        % store the solution of the current time instance in a cell array
        tran_sols{i,1} = t;
        tran_sols{i,2} = cir_sol;
        
        %reinitialize G and rhs for the next time instance
        G  = zeros(tot_vars, tot_vars);
        rhs = zeros(tot_vars, 1);
    end
    
    sol = tran_sols; 
    %in case of transient solution the returned sol variable is a cell
    %array of many solutions.
    %but for ssa it was only an array.
    return;    
end

end

