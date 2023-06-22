 %FOR AC TRANSIENT FIRST CONVERT AC SOURCES(VSIN, ISIN) TO DC
        elements = ori_elements;
        
        if analysis == 4
            addpath lib;
            for m = 1:tot_el
                if elements{m}.type == "VSIN" || elements{m}.type == "ISIN"
                    el = elements{m};
                    mag = el.value(1);
                    f = el.value(2);
                    ip = el.value(3); %initaial phase
                    
                    dc_val = mag*sin(2*pi*f*t + pi*ip/180);
                    name = el.name;
                    nodes = el.nodes;
                    elements{m} = VDC(name, nodes, dc_val);
                end
            end
        end
        