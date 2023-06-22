% nl = ["I1 0 1 DC 3";
%     "R1 0 1 2";
%     "R2 1 2 6";
%     "R3 2 0 7";
%     "I 2 0 DC 12";
%     ".SSA";
%     ".TRA"];
%
% [ele, q] = nlparserf(nl);

function [elements, queries] = nlparser(nl)
%netlist parser: this function takes a netlist as input and outputs a cell array of
%element objects. all the elements in the netlist is converted to objects

%% making a cell array of cell array first
% example
% {
%   {'R1', 1, 2, 1000};
%   {'V1', 1, 2, 'DC', 5}
% }
format long;
len_nl = length(nl);

cell_nl = cell(1, len_nl);

for i=1:len_nl
    stmt = nl(i);
    stmt = split(stmt);
    
    ls = length(stmt);
    temp_cell = cell(1,ls);
    for j = 1:ls
        temp = str2double(stmt(j));
        if isnan(temp)
            temp = char(stmt(j));
        end
        temp_cell{j} = temp;
    end
    
    cell_nl{i,1} = temp_cell;
end

%% making objects and filling the elements cell array
addpath lib;

elcount = 1;
qcount = 1; %query count

for i=1:length(cell_nl)
    stmt = cell_nl{i};
    el = stmt{1}(1); %element
    name = stmt{1}(1:end);
    
    if el == '.'
        % QUERIES
        % queries will be stored in the queries cell array of cell array
        % where each cell array of the cell array will hold a query
        
        ana_type = stmt{1}(2:end);
        
        query_cell = {}; %resetting query_cell array
        
        if ana_type == "SSA"
            query_cell{1} = ana_type;
            queries{qcount} = query_cell;
            
        elseif ana_type == "TRA"
            %.TRA start stopt stept UIC
            % UIC is optional, if UIC is present that means we have to use
            % initial condtion. if it is not present that means we don't
            % have to use initial condition
            
            query_cell{1} = string(ana_type);
            query_cell{2} = stmt{2};
            query_cell{3} = stmt{3};
            query_cell{4} = stmt{4};
            
            if length(stmt)>=5
                if stmt{5} == "UIC", uic = true;
                else, uic = false;
                end
                
                query_cell{5} = uic;
            end            
            
            
            queries{qcount} = query_cell;
        end
        
        qcount = qcount + 1;
        
    elseif el == "R" || el == "C" || el == "L"
        %R_name N+ N- val
        %C_name N+ N- val [IC]; InitialCondition is optional to add. it
        %holds the voltage at t= 0
        %L_name N+ N- val [IC]; InitialCondition is optional to add. it
        %holds the current at t= 0
        val = stmt{4};
        nodes = [stmt{2}, stmt{3}];
        if el == "C" || el == "L"
            if length(stmt) >= 5
                InC = stmt{5}; %initial condition
            else
                InC = 0;
            end
        end
        
        if el == "R" elements{elcount} = R(name, nodes, val);
        elseif el == "C"
            elements{elcount} = C(name, nodes, val);
            elements{elcount}.IC = InC;
            elements{elcount}.prev_val = InC;
        elseif el == "L"
            elements{elcount} = L(name, nodes, val);
            elements{elcount}.IC = InC;
            elements{elcount}.prev_val = InC;
        end
        
        elcount = elcount + 1;
        
    elseif (el == "V" || el == "I") && stmt{4} == "DC"
        %VDC
        %IDC
        val = stmt{5};
        nodes = [stmt{2}, stmt{3}];
        
        if el == "V" elements{elcount} = VDC(name, nodes, val);
        elseif el == "I" elements{elcount} = IDC(name, nodes, val);
            
        end
        
        elcount = elcount + 1;
        
    elseif (el == "V" || el == "I") && stmt{4} == "SIN"
        %VSIN sinusoidal voltage source
        % V N+ N- SIN mag freq ini_phase(in degree)
        %ISIN sinusoidal current source
        % I N+ N- SIN mag freq ini_phase(in degree)
        
        mag = stmt{5};
        freq = stmt{6};
        iph = stmt{7};
        val = [mag freq iph];
        
        nodes = [stmt{2}, stmt{3}];
        
        if el == "V"
            elements{elcount} = VSIN(name, nodes, val);
        elseif el == "I"
            elements{elcount} = ISIN(name, nodes, val);
        end
        
        elcount = elcount + 1;
        
    elseif el == "G"
        %VCCS
        val = stmt{6};
        nodes = [stmt{2}, stmt{3}, stmt{4}, stmt{5}];
        elements{elcount} = VCCS(name, nodes, val);
        elcount = elcount + 1;
    elseif el == "F" || el == "H"
        %CCCS
        % Vdummy NC+ NC- val
        % Fname N+ N- Vdummy Fval
        % Hname N+ N- Vdummy Hval
        % the dummy voltage source must be declared before the F statement
        
        val = stmt{5};
        main_nodes = [stmt{2}, stmt{3}];
        
        %finding the dummy voltage source to know the control nodes
        Vdum_name = stmt{4}; %name of dummy voltage source
        for j = 1:length(elements)
            if string(elements{j}.name) == string(Vdum_name)
                Vdum = elements{j};
                contrl_nodes = Vdum.nodes;
                break;
            end
        end
        
        nodes = [main_nodes, contrl_nodes];
        
        if el == "F"
            elements{elcount} = CCCS(name, nodes, val);
        elseif el == "H"
            elements{elcount} = CCVS(name, nodes, val);
        end
        elcount = elcount + 1;
    elseif el == "E"
        % VCVS
        % Ek N+ N- NC+ NC- GainFactor
        
        val = stmt{6};
        nodes = [stmt{2}, stmt{3}, stmt{4}, stmt{5}];
        elements{elcount} = VCVS(name, nodes, val);
        elcount = elcount + 1;
    elseif el == "S"
        %SC short circuit
        % S N+ N-
        val = [];
        nodes = [stmt{2}, stmt{3}];
        elements{elcount} = SC(name, nodes, val);
        elcount = elcount + 1;
    elseif el == "U"
        %OPENING OR CLOSING SWITCH
        %U N1 N2 TCLOSE/TOPEN closing_time;
        % example: U 1 3 TCLOSE 2; this switch closes at t = 2 and is open before t = 2
        % example: U 2 5 TOPEN 3; this one is closed before t = 3 and opened after t = 3
        %%%% example: U 1 2 4 TSW 2; before t = 2s, the switch connects node 1 and 2, after t = 2s, the switch connects node 1 and 3 
        
        val = stmt{5};
        type = stmt{4};
        nodes = [stmt{2}, stmt{3}];
        
        if type == "TCLOSE" elements{elcount} = UTCLOSE(name, nodes, val);
%         elseif type == "TOPEN" elements{elcount} = UTCLOSE(name, nodes, val);
        end
        
        elcount = elcount + 1;
    end
end

end

