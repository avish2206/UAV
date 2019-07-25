function is_valid = zone_test(nodes,node1,node2,param,heading)
global pathreconstruction;
%% unpack parameters
zone = param.space.zone;
obs = param.space.obs;
turn_rate = param.uav.turn_rate;

%% Iterate through lines
if pathreconstruction
    oldindex = 0;
    for k = 0.1:0.1:1
        node = k*node1 + (1-k)*node2;
        [is_valid_basic,index] = zone_test_basic(node,param,heading,turn_rate);

        if ~is_valid_basic
            is_valid = 0;   
            return;
        end

        if edge_test(node,zone(1:2,index),obs)
            continue;
        end

        if k ~=0.1 && index==oldindex
            if path_reconstruction(node,path2,param) == 1
                continue;
            else
               % do nothing, we need to manually test the path 
            end
        else
            [is_valid_dyn,path2] = zone_test_dynamic(nodes,node,zone(:,index),param,heading);
            if ~is_valid_dyn
                is_valid = 0;
                return;
            end
        end
        oldindex = index;
    end
    is_valid = 1;

else
    for k = 0.1:0.1:1
        node = k*node1 + (1-k)*node2;
        [is_valid_basic,index] = zone_test_basic(node,param,heading,turn_rate);

        if ~is_valid_basic
            is_valid = 0;   
            return;
        end

        if edge_test(node,zone(1:2,index),obs)
            continue;
        end

        if ~zone_test_dynamic(nodes,node,zone(:,index),param,heading)
            is_valid = 0;
            return;
        end
    end
    is_valid = 1;
end

