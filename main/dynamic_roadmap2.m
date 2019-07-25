function path = dynamic_roadmap2(param)

global obstaclecluster;

%% unpack parameters
init = param.uav.start;
goal = param.uav.goal;
vel = param.uav.velocity;
init_heading = param.uav.init_heading;
turn_rate = param.uav.turn_rate;
obs  = param.space.obs;
zone = param.space.zone;
npoints = param.sample.npoints;
radius = param.sample.range;
cluster_range = param.cluster.range;
wind = param.wind;

%% Sample the state space
load('nodes2.mat');
%nodes = [goal,init(1) + (goal(1)-init(1))*abs(rand(2,npoints))];
% save('nodes.mat','nodes');
% scatter(nodes(1,:),nodes(2,:),'k');
%% Define preliminary variables
fringe = []; 
current = init;
visited = [current;0;0];
iteration_count = 1;
heading = init_heading;

clusters = cell(1,size(zone,2));
cluster_min = cell(1,size(zone,2));
cluster_sizes = zeros(1,size(zone,2));
cluster.clusters = clusters;
cluster.cluster_min = cluster_min;
cluster.cluster_sizes = cluster_sizes;
cluster.cluster_range = cluster_range;
clear 'clusters' 'cluster_min' 'cluster_sizes' 'cluster_range'

%% main loop
while current~=goal
    [idx, D] = rangesearch(nodes', current', radius);
    idx = idx{1};
    D = D{1};
    cost = visited(4,end);
    infeasible_index = [];
    for k = 1 : length(idx) 
        temp = nodes(:,idx(k));
        new_heading = calculate_new_heading(current,temp);
        if edge_test(current,temp,obs)
            [is_valid, invalid_node,cluster_flag,cluster_info] = zone_test2(nodes,current,temp,param,new_heading,cluster);
            if is_valid
                vel_proj = vel + calculate_projection(current,temp,wind);
                T_proj = D(k)/vel_proj;
                turn_time = calculate_turn_cost(current,temp,heading,turn_rate);
                vel_proj = vel + calculate_projection(temp,goal,wind);
                goal_heuristic = norm(temp-goal)/vel_proj + calculate_turn_cost(temp,goal,heading,turn_rate);
                [flag,index] = is_fringe(idx(k),fringe);
                if flag 
                    if cost+T_proj+turn_time+goal_heuristic < fringe(4,index)
                        fringe(:,index) = [temp;size(visited,2);cost+T_proj+goal_heuristic+turn_time;cost+T_proj+turn_time;new_heading;idx(k)];
                        %plot([current(1), temp(1)], [current(2), temp(2)], 'c', 'linewidth', 0.25);
                    else
                        continue;
                    end
                else
                    fringe = [fringe,[temp;size(visited,2);cost+T_proj+goal_heuristic+turn_time;cost+T_proj+turn_time;new_heading;idx(k)]];
                    %plot([current(1), temp(1)], [current(2), temp(2)], 'c', 'linewidth', 0.25);
                end
            else
                infeasible_index = [infeasible_index, idx(k)];
                if obstaclecluster
                    if ~isempty(invalid_node)
                        cluster = cluster_add(cluster,invalid_node,cluster_flag,cluster_info);
                    end
                end
            end
        else
            nodes(:,idx(k)) = nan(2,1);
        end
    end 
    if isempty(fringe)
        path = [];
        display('No valid path found!');
        return;
    end
    fringe = sortrows(fringe',4)';
    current = fringe(1:2,1);
    remove_index = fringe(end,1);
    visited = [visited,[current;fringe(3,1);fringe(5,1)]];
    heading = fringe(6,1);
    fringe(:,1) = [];
    nodes(:,[remove_index,infeasible_index]) = nan(2,1+length(infeasible_index));
    iteration_count = iteration_count + 1;
    fprintf('Current iteration: %d\n',iteration_count);
end

fprintf('\nRoadmap generated!\nIterations:%d\nCost of path (time):%.2f seconds\n',iteration_count,visited(4,end));
path = generate_path(visited,vel,turn_rate,'r',wind);
%plot_clusters(cluster);
    
end

