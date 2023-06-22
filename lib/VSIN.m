classdef VSIN < device
    %VSIN is the sinusoidal voltage source
    %   it's value is an array which holds it's magnitude, frequency and
    %   initaial phase angle(in degree).
    %   value = [mag, freq, ini_phase]
    
    methods
        function obj = VSIN(name, nodes, value)
            %VSIN Construct an instance of this class
            obj = obj@device(name, nodes, value, 'VSIN', 2);
            obj.extra_var = {false;
                false; %VSIN cannot be in dc ssa or dc tra
                [true, 1, nodes];
                [true 1 nodes]};
        end
        
        function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            
            analysis = ana{1};
            
            if analysis == 1
                %DC SSA
                
                %vsin cannot be part of dc ssa
                disp("AC voltage source not valid in DC steady state analysis");
                modiG = G;
                modirhs = rhs;
                
                return
                
            elseif analysis == 2
                %DC TRA
                
                
                return
                
            elseif analysis == 3
                %AC SSA
                
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
                
                %finding the phasor value in cartesian form
                val = obj.value;
                mag = val(1);
                ini_ph = val(3);
                ini_ph = (pi/180)*ini_ph; % converted in radian
                [x, y] = pol2cart(ini_ph, mag);
                phasor_val = x + 1j*y;
                
                rhs(r, 1) = rhs(r, 1) +  phasor_val;
                
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

