%% generateRoadmap.m                

function [nodes, distMatrix, heuristic] = generate_roadmap(npoints,radius,init,final,obs,radius_obstacle,zone)

    nodes = [init,final,zone];
    distMatrix = zeros(npoints); 
    heuristic = zeros(1,npoints); 
    heuristic(1) = norm(final-init);
    heuristic(2) = 0;
    
    offset = 2+length(zone);
    
    for i = 1 : npoints-offset       

        while true
            new = init(1)+(final(1)-init(1))*abs(rand(2,1));
            if collision_test(new,obs,radius_obstacle)
                break;
            end
        end
        
        heuristic(i+offset) = norm(new-final);
        nodes = [nodes, new];
        
        [idx, D] = rangesearch(nodes', new', radius);
        idx = idx{1};
        if length(idx) == 1
            continue;
        end
        D = D{1};
        for k = 2 : length(idx) 
            if edge_test(new,nodes(:,idx(k)),obs,radius_obstacle);
                plot([nodes(1,end), nodes(1,idx(k))], [nodes(2,end), nodes(2,idx(k))], 'c', 'linewidth', 0.5); % plot the edge
                distMatrix(length(nodes),idx(k)) = D(k); % add in symmetric positions in distMatrix
                distMatrix(idx(k),length(nodes)) = D(k);
            end
        end 
    end    
end

