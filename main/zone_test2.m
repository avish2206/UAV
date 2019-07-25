function [is_valid,invalid_node,cluster_flag,cluster_info] = zone_test2(nodes,node1,node2,param,heading,cluster)

global pathreconstruction;
global obstaclecluster

%% unpack parameters
zone = param.space.zone;
obs = param.space.obs;
turn_rate = param.uav.turn_rate;

invalid_node = [];
cluster_flag = [];
cluster_info = [];

%% Iterate through lines
if pathreconstruction
    oldindex = 0;
    for k = 0.1:0.1:1
        node = k*node2 + (1-k)*node1;
        [is_valid_basic,index,total_cost] = zone_test_basic(node,param,heading,turn_rate);

        if ~is_valid_basic
            is_valid = 0;   
            return;
        end

        if edge_test(node,zone(1:2,index),obs)
            continue;
        end
        
        if obstaclecluster
            [flag,cluster_flag,cluster_info] = cluster_check(node,index,cluster,total_cost);
            if flag == 0
                is_valid = 0; % if we have found a node that belongs to a current cluster
                invalid_node = node;
                return;
            end
        end

        if k ~=0.1 && index==oldindex
            [is_valid_dyn,path2] = path_reconstruction2(path2,nodes,node,zone(:,index),param,heading);
            if ~is_valid_dyn
                is_valid = 0;
                invalid_node = node;
                return;
            end
        else
            [is_valid_dyn,path2] = zone_test_dynamic(nodes,node,zone(:,index),param,heading);
            if ~is_valid_dyn
                is_valid = 0;
                invalid_node = node;
                return;
            end
        end
        oldindex = index;
    end
    is_valid = 1;

else
    for k = 0.1:0.1:1
        node = k*node2 + (1-k)*node1;
        [is_valid_basic,index,total_cost] = zone_test_basic(node,param,heading,turn_rate);

        if ~is_valid_basic
            is_valid = 0;   
            return;
        end

        if edge_test(node,zone(1:2,index),obs)
            continue;
        end
        
        if obstaclecluster
            [flag,cluster_flag,cluster_info] = cluster_check(node,index,cluster,total_cost);
            if flag == 0
                is_valid = 0; % if we have found a node that belongs to a current cluster
                invalid_node = node;
                return;
            end
        end

        if ~zone_test_dynamic(nodes,node,zone(:,index),param,heading)
            is_valid = 0;
            invalid_node = node;
            return;
        end
    end
    is_valid = 1;
end

