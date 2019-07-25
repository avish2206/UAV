function is_valid = path_reconstruction(node,path,param)
    velocity = param.uav.velocity;
    threshold = param.uav.descent_time;
    obs = param.space.obs;
    
    path_nodes = path(1:2,:);
    cost       = path(3,:);
    
    while ~isempty(path_nodes)
        [idx, D] = knnsearch(path_nodes', node', 'K',1);
        if edge_test(node,path_nodes(:,idx),obs)
            break;
        end
        path_nodes(:,idx) = [];
        cost(idx) = [];
    end
    if isempty(path_nodes)
        is_valid = 0; % find path manually
        return;
    end
    T = D(1)/velocity;
    if T + cost(idx) < threshold
        is_valid = 1;
        return;
    end
    is_valid = 0;

end

