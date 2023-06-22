classdef R < device
    %this is a resistor
    %   temparature independent and constant resistance
    
    methods
        function obj = R(name,nodes, value)
            obj = obj@device(name, nodes, value, 'R', 2);
            obj.extra_var = {false;
                false;
                false;
                false};
        end
        
        function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            
            analysis = ana{1};
            
            if analysis == 1 || analysis == 3 || analysis == 2
                %DC SSA, AC SSA, DC TRA
                
                n = obj.nodes; %nodes
                ev = obj.value; %element value
                
                G(n(1)+1, n(1)+1) = G(n(1)+1, n(1)+1) + (1/ev);
                G(n(1)+1, n(2)+1) = G(n(1)+1, n(2)+1) - (1/ev);
                G(n(2)+1, n(1)+1) = G(n(2)+1, n(1)+1) - (1/ev);
                G(n(2)+1, n(2)+1) = G(n(2)+1, n(2)+1) + (1/ev);
                
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

