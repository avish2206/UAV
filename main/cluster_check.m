function [flag,cluster_flag,cluster_info] = cluster_check(node,index,cluster,cost)    

    %%unpack cluster
    cluster_sizes = cluster.cluster_sizes;
    cluster_min = cluster.cluster_min;
    cluster_range = cluster.cluster_range;
    cluster_info = [index;cost];
    
    if cluster_sizes(index) == 0
        flag = 1; % there are no clusters corresponding to the specific zone
        cluster_flag = 0;
        return;
    end
    
    for i = 1:cluster_sizes(index)
        if norm(node-cluster_min{i,index}(1:2)) < cluster_range
            cluster_info = [i;index;cost];
            if cost < cluster_min{i,index}(3) % IF the cost is lower than the current minimum
                flag = 1; % we need to update the minimum
                cluster_flag = 2;
                return;
            else % otherwise add to the corresponding cluster
                flag = 0;
                cluster_flag = 3;
                return;
            end
        end
    end
    
    flag = 1; % it doesnt exist within one of the current clusters, we need to check
    cluster_flag = 1;
    return;
end
    


