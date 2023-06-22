classdef SC < device
    %SC this is a short circuit between two nodes
    %   It's netlist syntax is: S N+ N-
    %   Short circuit stamp is the same as that of a 0V VDC.
    %   Hence it can be simulated by placing a 0V VDC also.
    
    methods
        function obj = SC(name, nodes, value)
            %SC Construct an instance of this class
            obj = obj@device(name, nodes, value, 'S', 2);
            obj.extra_var = {[true, 1, nodes];
                                [true, 1, nodes];
                                [true, 1, nodes]};
        end
        
        function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            
            analysis = ana{1};
            
            if analysis == 1 || analysis == 3
                %DC SSA, AC SSA
                
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
                
                
                modiG = G;
                modirhs = rhs;
                
            elseif analysis == 2
                %DC TRA             
          
            elseif analysis == 4
                %AC TRA
                
                
            end    
        end
    end
end

