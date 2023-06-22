classdef UTCLOSE < device
    %UTCLOSE this is a switch which closes at specified time t
    %   before closing the switch acts as open circuit(infinite resistance)
    %   after closing the switch acts as a short cicuit.
    %   it's value property holds the tClose value i.e. when the switch
    %   will close.
    properties
        is_sw = true; %is it a switch
    end
    
    methods
        function obj = UTCLOSE(name,nodes, value)
            %UTCLOSE Construct an instance of this class
            obj = obj@device(name, nodes, value, 'UTCLOSE', 2);
            obj.extra_var = {false; %before switch closing, DC SSA analysis is performed,where utclose acts as a open circuit
                [true, 1, nodes]; %after switch closing utclose acts as short circuit in DC TRA
                false};
        end
        
        function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            analysis = ana{1};
            
            if analysis == 1
                %before switch closing, DC SSA analysis is performed,where utclose acts as a open circuit
                ev = Inf;
                n = obj.nodes; %nodes
                
                G(n(1)+1, n(1)+1) = G(n(1)+1, n(1)+1) + (1/ev);
                G(n(1)+1, n(2)+1) = G(n(1)+1, n(2)+1) - (1/ev);
                G(n(2)+1, n(1)+1) = G(n(2)+1, n(1)+1) - (1/ev);
                G(n(2)+1, n(2)+1) = G(n(2)+1, n(2)+1) + (1/ev);
                
                modiG = G;
                modirhs = rhs;
                
                return
            elseif analysis == 2
                %after switch closing utclose acts as short circuit in DC TRA
                
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
                
            end
            
        end
    end
end

