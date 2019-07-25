function cluster = cluster_add(cluster,invalid_node,cluster_flag,cluster_info)
    clusters = cluster.clusters;
    cluster_min = cluster.cluster_min;
    cluster_sizes = cluster.cluster_sizes;
    
    if cluster_flag == 0 %currently no index for zone
        index = cluster_info(1);
        cost = cluster_info(2);
        clusters{1,index} = invalid_node;
        cluster_sizes(index) = 1;
        cluster_min{1,index} = [invalid_node;cost];
    elseif cluster_flag == 1 %add another index for current zone
        index = cluster_info(1);
        cost = cluster_info(2);
        cluster_sizes(index) = cluster_sizes(index) + 1;
        clusters{cluster_sizes(index),index} = invalid_node;
        cluster_min{cluster_sizes(index),index} = [invalid_node;cost];
    elseif cluster_flag == 2 % update current minimum inside a cluster
        i = cluster_info(1);
        index = cluster_info(2);
        cost = cluster_info(3);
        clusters{i,index} = [clusters{i,index},invalid_node];
        cluster_min{i,index} = [invalid_node;cost];
    else % add to a current cluster
        i = cluster_info(1);
        index = cluster_info(2);
        clusters{i,index} = [clusters{i,index},invalid_node];
    end
    
    cluster.clusters = clusters;
    cluster.cluster_min = cluster_min;
    cluster.cluster_sizes = cluster_sizes;
end

