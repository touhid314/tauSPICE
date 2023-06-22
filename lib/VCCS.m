classdef VCCS < device
    %VCCS is voltage controlled current source. it's the G element
    %   the value attributE holds the amplification factor Gk
    
    methods
        function obj = VCCS(name, nodes, value)
            %VDC Construct an instance of this class
            obj = obj@device(name, nodes, value, 'G', 4);
            obj.extra_var = {false;
                                false;
                                false};
        end
        
        function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            %G here is the conductance matrix
            
            analysis = ana{1};
            
            if analysis == 1 || analysis == 3
                %DC SSA, AC SSA
                
                np = obj.nodes(1); % N+
                nm = obj.nodes(2); % N-
                ncp = obj.nodes(3); % NC+
                ncm = obj.nodes(4); % NC-
                
                Gk = obj.value;
                
                G(np+1, ncp+1) = G(np+1, ncp+1) + Gk;
                G(np+1, ncm+1) = G(np+1, ncm+1) - Gk;
                G(nm+1, ncp+1) = G(nm+1, ncp+1) - Gk;
                G(nm+1, ncm+1) = G(nm+1, ncm+1) + Gk;
                
                modiG = G;
                
                modirhs = rhs;
                return
                
            elseif analysis == 2
                %DC TRA
                
                
                return
                
            elseif analysis == 4
                %AC TRA
                
                
                
                return
                
            end

        end
    end
end

