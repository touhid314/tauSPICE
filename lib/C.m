classdef C < device
    %C this is an ideal linear capacitor.
    
    properties (Constant)
        mem_el = true; %it is a memory element
    end
    properties
        IC %initial condition; holds the voltage at t=0.
        %but during the cycles of transient analysis it holds the
        %previous voltage.
        prev_val; %holds the voltage across the capacitor for the previous time instance.
      
    end
    
    methods
        function obj = C(name, nodes, value)
            %C Construct an instance of this class
            obj = obj@device(name, nodes, value, 'C', 2);
            %row 1 - dc ssa, row 2 - dc tra, row 3 - ac ssa, row 4 - ac tra
            obj.extra_var = {false;
                false;
                false};
        end
        
        function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            
            analysis = ana{1};
            
            if analysis == 1
                % dc ssa
                % in DC steady state capacitor is open circuit meaning
                % it acts as a resistor with infinite resistance
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
                %dc tra

                %nodal analysis stamping
                np = obj.nodes(1); % + node
                nm = obj.nodes(2); % - node
                
                C = obj.value;
                h = ana{4}; %time step
                
                G(np+1, np+1) = G(np+1, np+1) + C/h;
                G(np+1, nm+1) = G(np+1, nm+1)- C/h;
                G(nm+1, np+1) = G(nm+1, np+1)- C/h;
                G(nm+1, nm+1) = G(nm+1, nm+1) + C/h;
                
                rhs(np+1) = (C/h)*obj.prev_val;
                rhs(nm+1) = (-C/h)*obj.prev_val;
                
                modiG = G;
                modirhs = rhs;
                return
                
            elseif analysis == 3
                %ac ssa
                
                % stamp according to phasor
                n = obj.nodes; %nodes
                C = obj.value; %capacitance
                f = ana{2}; %frequency
                w = 2*pi*f; %angular frequency
                adm = 1j*w*C; %admittance; here 1j is the sqrt(-1)
                
                G(n(1)+1, n(1)+1) = G(n(1)+1, n(1)+1) + adm;
                G(n(1)+1, n(2)+1) = G(n(1)+1, n(2)+1) - adm;
                G(n(2)+1, n(1)+1) = G(n(2)+1, n(1)+1) - adm;
                G(n(2)+1, n(2)+1) = G(n(2)+1, n(2)+1) + adm;
                
                modiG = G;
                modirhs = rhs;
                
            elseif analysis == 4
                %AC TRA
                
            end
        end
        
        
        function obj = update_mem(obj, cir_sol, vars_index)
            np = obj.nodes(1);
            nm = obj.nodes(2);
            
            if np == 0 vp =0;
            elseif nm == 0 vm = 0;
            end
            
            for i = 1:length(vars_index)
                if isequal(vars_index{i},np)
                    vp = cir_sol(i); %voltage at  pos node
                elseif isequal(vars_index{i},nm)
                    vm = cir_sol(i);                    
                end
            end
            
            v = vp - vm; %voltage across the capacitor
            obj.prev_val = v;
        end
    end
    
end

