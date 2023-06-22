classdef device
    %DEVICE is a superclass for all devices
    
    properties (SetAccess = private)
        no_of_nodes
        type %for example R, C, L
    end
    properties
        name
        nodes
        value
        extra_var 
        %if the element adds extra current variable
        % in the conductance matrix, then this
        % property holds the nodes of that branch.
        % otherwise it just holds false(0).
        % format: {[true, no_of_extra_vars, br1node+,% br1node-, br2node+, br2node-...];
        %           [false]}
        % row 1 holds info for dc ssa, row 2 for dc tra....
        % row1 - dc ssa, row2 - dc tra, row3 - ac ssa, row4 - ac tra
    end
    
    methods
        function obj = device(name,nodes, value, type, no_of_nodes)
            %DEVICE Construct an instance of this class
            %   Detailed explanation goes here
            obj.name = name;
            obj.nodes = nodes;
            obj.value = value;
            obj.type = type;
            obj.no_of_nodes = no_of_nodes;
        end
        
        
    end
    
    
end

