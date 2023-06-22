classdef CCCS < device
    %CCCS is the current controlled current source. It is the F element
    %   value of CCCS is its gain
    
    
    methods
        function obj = CCCS(name, nodes, value)
            %CCCS Construct an instance of this class
            obj = obj@device(name, nodes, value, 'F', 4);
            obj.extra_var = {false;
                                [false];
                                false};
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
                
                t = [ncp, ncm];
                
                for i= 1:length(vars_index)
                    if isequal(t ,vars_index{i})
                        r = i + 1;
                    end
                end
                
                %doing stamping
                Fk = obj.value;
                
                
                G(np+1, r) = G(np+1, r) + Fk;
                G(nm+1, r) = G(nm+1, r) - Fk;
                
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

