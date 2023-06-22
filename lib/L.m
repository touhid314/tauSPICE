classdef L < device
    %L is the ideal linear inductor.
    
    properties (Constant)
        mem_el = true; %it is a memory element
    end
    
    properties
        IC %initial condition; holds the current at t=0.
            %but during the cycles of transient analysis it holds the
            %previous current.
        prev_val; %holds the current through the capacitor for the previous time instance.
    end
    
    methods
        function obj = L(name, nodes, value)
            %C Construct an instance of this class
            obj = obj@device(name, nodes, value, 'L', 2);
            obj.extra_var = {[true 1 nodes];
                                [true 1 nodes];
                                false};
        end
        
        function [modiG, modirhs] = stamper(obj,G, vars_index, rhs, ana)
            
            analysis = ana{1};
            
            if analysis == 1 || analysis == 2
                %DC SSA, DC TRA
                
                % in DC SSA inductor is short circuit meaning
                % it acts as a 0V voltage source
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
                
                if analysis == 2
                    %extra things to do for dc tra
                    L = obj.value;
                    h = ana{4}; %time step
                    
                    G(r,r) = -(L/h);
                    rhs(r) = rhs(r) - (L/h)*obj.prev_val;
                end
                
                modiG = G;
                modirhs = rhs;
                
                return
                
            elseif analysis == 3
                %AC SSA
                
                % stamp according to phasor
                n = obj.nodes; %nodes
                L = obj.value; %capacitance
                f = ana{2}; %frequency
                w = 2*pi*f; %angular frequency
                adm = 1/(1j*w*L); %admittance; here 1j is the sqrt(-1)
                
                G(n(1)+1, n(1)+1) = G(n(1)+1, n(1)+1) + adm;
                G(n(1)+1, n(2)+1) = G(n(1)+1, n(2)+1) - adm;
                G(n(2)+1, n(1)+1) = G(n(2)+1, n(1)+1) - adm;
                G(n(2)+1, n(2)+1) = G(n(2)+1, n(2)+1) + adm;
                
                modiG = G;
                modirhs = rhs;
               
                return
                
            elseif analysis == 4
                %AC TRA
                
                
            end          
        end
        
        
        function obj = update_mem(obj, cir_sol, vars_index)
            np = obj.nodes(1);
            nm = obj.nodes(2);
            
            for i = 1:length(vars_index)
                if isequal(vars_index{i},[np,nm])
                    il = cir_sol(i); %current through L                  
                end
            end
            
            obj.prev_val = il;
        end
        
    end
end

