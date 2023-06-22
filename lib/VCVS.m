classdef VCVS < device
    %VCVS Voltage controlled voltage source. This is the E element
    %   the value attribute holds the gain factor
    
    
    methods
        function obj = VCVS(name, nodes, value)
            %VCVS Construct an instance of this class
            obj = obj@device(name, nodes, value, 'E', 4);
            obj.extra_var = {[true, 1, nodes(1, 1:2)];
                                [true, 1, nodes(1, 1:2)];
                                [true, 1, nodes(1, 1:2)]};
        end
        
        function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            
            analysis = ana{1};
            
            if analysis == 1 || analysis == 3
                %DC SSA, AC SSA
                
                %determining row of branch current
                np = obj.nodes(1);
                nm = obj.nodes(2);
                ncp = obj.nodes(3);
                ncm = obj.nodes(4);
                
                t = [np, nm]; %branch current
                
                for i= 1:length(vars_index)
                    if isequal(t ,vars_index{i})
                        r = i + 1;
                    end
                end
                
                %stamping
                Ek = obj.value;
                
                G(np+1, r) = G(np+1, r) + 1;
                G(nm+1, r) = G(nm+1, r) - 1;
                G(r, np+1) = G(r, np+1)+ 1;
                G(r, nm+1) = G(r, nm+1) - 1;
                G(r, ncp+1) = G(r, ncp+1) - Ek;
                G(r, ncm+1) = G(r, ncm+1) + Ek;
                
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

