    
    
    %FIGURING OUT SWITCH TIME
    t_sw = NaN;
    for i = 1:tot_el
        if isprop(elements{i}, "is_sw") == true
            t_sw = elements{i}.value; %switch close/open/switching time            
        end
    end
    
    if isnan(t_sw) == true
        %if t_sw is still NaN that means there is no switch in the circuit
        disp("transient analysis can not be performed when there is no sudden change in the circuit");
    end
        
    

% IF UIC = FALSE, PERFORMING DC SSA TO RETRIEVE INITIAL CONDITION OF MEMORY ELEMENT
    if uic == false
        %performing dc ssa
        % stamping
        ana = {1}; %dc ssa
        
        for i =1:tot_el
            [G, rhs] = elements{i}.stamper(G,vars_index, rhs, ana);
        end
        
        % solution
        sol = solvemat(G, rhs);
        
        %storing the ssa solution in the tran_sols cell array
        for i = 1:(t_sw/step)
            tran_sols{i,1} = start + step*i;
            tran_sols{i,2} = sol;
        end
        
        %finding the IC of memory elements
        for k = 1:tot_el
            if isprop(elements{k}, "mem_el")
                elements{k} = elements{k}.update_mem(cir_sol, vars_index);
            end
        end
        
    end