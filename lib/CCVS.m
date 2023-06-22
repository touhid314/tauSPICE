classdef CCVS < device
    %CCVS Curent controlled voltage source. This is the H element
    %   the value attribute holds the gain factor
    
    methods
        function obj = CCVS(name, nodes, value)
            %CCVS Construct an instance of this class
            obj = obj@device(name, nodes, value, 'H', 4);
            obj.extra_var = {[true, 1, nodes(1,1:2)];
                [true, 1, nodes(1,1:2)];
                [true, 1, nodes(1,1:2)]};
        end
        
        function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            
            analysis = ana{1};
            
            if analysis == 1 || analysis == 3
                %DC SSA, AC TRA
                
                %determining row of branch current
                np = obj.nodes(1); %N+
                nm = obj.nodes(2); %N-
                ncp = obj.nodes(3); %NC+
                ncm = obj.nodes(4); %NC-
                
                tm = [np, nm]; %branch current for the main branch
                tc = [ncp, ncm]; %branch current for the cotrol branch
                
                for i= 1:length(vars_index)
                    if isequal(tm ,vars_index{i})
                        rm = i + 1; %row for main branch
                    elseif isequal(tc ,vars_index{i})
                        rc = i + 1; % row for control branch
                    end
                end
                
                %stamping
                Hk = obj.value;
                
                %  for rm(ain)
                G(np+1, rm) = G(np+1, rm) + 1;
                G(nm+1, rm) = G(nm+1, rm) - 1;
                G(rm, np+1) = G(rm, np+1) + 1;
                G(rm, nm+1) = G(rm, nm+1)-1;
                
                % for rc(ontrol)
                G(rm, rc) = G(rm, rc) - Hk;
                
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

