function [tot_vars, vars_index] = var_counter(elements, analysis)
%VAR_COUNTER this function determines how many variables need to be solved
%in the circuit

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

count = tot_node + 1;
for i=1:tot_el
    
    ext_var_arr = elements{i}.extra_var; %ext_var_arr holds the extra variable cell array
    
    ext_var = ext_var_arr{analysis}; %this holds the extra_variable array for the current analysis
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

end

