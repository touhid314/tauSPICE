function [modiG, modirhs] = stamper(cmd_line, cond_mat, rhs)
%STAMPER stamps the given conductace matrix and rhs for the specified input

%assigning short names
G = cond_mat;
cl = cmd_line;

el_name = cl{1}(1);

%resistor
if el_name == "R"
    n = [cl{2}, cl{3}]; %nodes
    ev = cl{4}; %element value
    
    G(n(1)+1, n(1)+1) = G(n(1)+1, n(1)+1) + (1/ev);
    G(n(1)+1, n(2)+1) = G(n(1)+1, n(2)+1) - (1/ev);
    G(n(2)+1, n(1)+1) = G(n(2)+1, n(1)+1) - (1/ev);
    G(n(2)+1, n(2)+1) = G(n(2)+1, n(2)+1) + (1/ev);

%current source
elseif el_name == "I"
    n = [cl{2}, cl{3}]; %nodes
    ev = cl{5}; %element value
    
    rhs(n(1)+1) = rhs(n(1)+1) - ev;
    rhs(n(2)+1) = rhs(n(2)+1) + ev;    
end

modiG = G;
modirhs = rhs;
end

