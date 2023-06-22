classdef ISIN < device
    %ISIN this is the sinusoidal current source
    %   it's value is an array which holds it's magnitude, frequency and
    %   initaial phase angle(in degree).
    %   value = [mag, freq, ini_phase]   
    
    methods
        function obj = ISIN(name, nodes, value)
            %ISIN Construct an instance of this class
           
            obj = obj@device(name, nodes, value, 'ISIN', 2);
            obj.extra_var = {false;
                false;
                false};
        end
        
         function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            
            analysis = ana{1};
            
            if analysis == 1
                %DC SSA
                
                %isin cannot be part of dc ssa
                disp("AC current source not valid in DC steady state analysis");
                modiG = G;
                modirhs = rhs;
                
                return
                
            elseif analysis == 2
                %DC TRA
                
                
                return
                
            elseif analysis == 3
                %AC SSA
                
                %finding the phasor value in cartesian form
                val = obj.value;
                mag = val(1);
                ini_ph = val(3); % in degree
                ini_ph = (pi/180)*ini_ph; % converted in radian
                [x, y] = pol2cart(ini_ph, mag);
                phasor_val = x + 1j*y;
                
                np = obj.nodes(1);
                nm = obj.nodes(2);
                
                rhs(np) = rhs(np) -(phasor_val);
                rhs(nm) = rhs(nm)+ phasor_val;
                
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

