%                 % determining branch current nodes
%                 t = obj.nodes;
%                 
%                 for i= 1:length(vars_index)
%                     if isequal(t,vars_index{i})
%                         r = i;
%                         break;
%                     end
%                 end
%                 np = obj.nodes(1); % + node
%                 nm = obj.nodes(2); % - node
%                 
%                 C = obj.value;
%                 h = ana{4}; %time step
%                 
%                 %stamping
%                 
%                 G(r, np + 1) = G(r, np + 1)+ C/h;
%                 G(r, nm + 1) = G(r, nm + 1) -(C/h);
%                 G(r,r) = G(r,r)- 1;
%                 G(np + 1, r) = G(np + 1, r)+ 1;
%                 G(nm + 1, r) = G(nm + 1, r)- 1;
%                 
%                 rhs(r, 1) = rhs(r,1) + (C/h) * obj.prev_val;
%               
%                 modiG = G;
%                 modirhs = rhs;