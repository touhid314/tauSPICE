classdef IDC < device
    %IDC is DC current source
    
    methods
        function obj = IDC(name,nodes, value)
            %I Construct an instance of this class
            obj = obj@device(name, nodes, value, 'IDC', 2);
            obj.extra_var = {false;
                false;
                false}; %actually idc is not valid for ac ssa
        end
        
        function [modiG, modirhs] = stamper(obj, G,vars_index, rhs, ana)
            
            analysis = ana{1};
            
            if analysis == 1
                %DC SSA
                
                n = obj.nodes; %nodes
                ev = obj.value; %element value
                
                rhs(n(1)+1) = rhs(n(1)+1) - ev;
                rhs(n(2)+1) = rhs(n(2)+1) + ev;
                
                modiG = G;
                
                modirhs = rhs;
                
                return
                
            elseif analysis == 2
                %DC TRA
                                
                return
                
            elseif analysis == 3
                %AC SSA
                
                %idc is not valid in ac ssa
                
                disp("DC current source is not valid in AC Steady state analysis");
                
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

