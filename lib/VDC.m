classdef VDC < device
    %VDC is DC voltage source
    
    methods
        function obj = VDC(name, nodes, value)
            %VDC Construct an instance of this class
            obj = obj@device(name, nodes, value, 'VDC', 2);
            obj.extra_var = {[true, 1, nodes];
                [true, 1, nodes];
                [true, 1, nodes]}; %only 0V vdc can be in ac ssa
        end
        
        function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            
            analysis = ana{1};
            
            if analysis == 1 || analysis == 3 || analysis == 2
                %DC SSA, AC SSA,DC TRA
                %NOTE: ONLY 0V VDC CAN BE PART OF AC SSA.
                %IF NOT IT WILL PROVIDE ERRONEOUS RESULT.
                if analysis == 3 && obj.value ~= 0
                    disp("DC voltage source not valid in AC steady state analysis");
                    modiG = G;
                    modirhs = rhs;
                    return
                end
                
                % determining branch current nodes
                t = obj.nodes;
                
                for i= 1:length(vars_index)
                    if isequal(t,vars_index{i})
                        r = i + 1;
                        break;
                    end
                end
                np = obj.nodes(1); % + node
                nm = obj.nodes(2); % - node
                
                %stamping
                G(r, np + 1) = 1;
                G(r, nm + 1) = -1;
                G(np + 1, r) = 1;
                G(nm + 1, r) = -1;
                
                rhs(r, 1) = rhs(r, 1) + obj.value;
                
                modiG = G;
                modirhs = rhs;
                
                return
                
            elseif analysis == 4
                %AC TRA               
                
                
                return
                
            end
            
        end
    end
end

