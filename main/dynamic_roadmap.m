function [] = dynamic_roadmap(param)

%% unpack parameters
init = param.uav.start;
goal = param.uav.goal;
vel = param.uav.velocity;
init_heading = param.uav.init_heading;
turn_rate = param.uav.turn_rate;
obs  = param.space.obs;
npoints = param.sample.npoints;
radius = param.sample.range;

%% Sample the state space
%load('nodes.mat');
nodes = [goal,init(1) + (goal(1)-init(1))*abs(rand(2,npoints))];
save('nodes.mat','nodes');
%% Define preliminary variables
fringe = []; 
current = init;
visited = [current;0;0];
iteration_count = 1;
heading = init_heading;
%% main loop
while current~=goal
    [idx, D] = rangesearch(nodes', current', radius);
    idx = idx{1};
    T = D{1}/vel;
    m = scatter(current(1),current(2),'ro');
    g = scatter(nodes(1,idx),nodes(2,idx),'go');
    cost = visited(4,end);
    delete_unvisited = [];
    unfeasible_zone = [];
    unfeasible_zone_index = [];
    unfeasible_obs = [];
    for k = 1 : length(idx) 
        temp = nodes(:,idx(k));
        new_heading = calculate_new_heading(current,temp);
        if edge_test(current,temp,obs)
            if zone_test(nodes,current,temp,param,new_heading)
                turn_time = 0;%calculate_turn_cost(current,temp,heading,turn_rate);
                goal_heuristic = norm(temp-goal)/vel;% + calculate_turn_cost(temp,goal,heading,turn_rate);
                delete_unvisited = [delete_unvisited,idx(k)]; 
                fringe = [fringe,[temp;size(visited,2);cost+T(k)+goal_heuristic+turn_time;cost+T(k)+turn_time;new_heading]];
                plot([current(1), temp(1)], [current(2), temp(2)], 'c', 'linewidth', 0.5);
            else
                %scatter(nodes(1,idx(k)),nodes(2,idx(k)),'k');
                %pause();
                %connect_unfeasible(unfeasible_zone,nodes(:,idx(k)),radius);
                unfeasible_zone = [unfeasible_zone, nodes(:,idx(k))];
                unfeasible_zone_index = [unfeasible_zone_index, idx(k)];
            end
        else
            unfeasible_obs = [unfeasible_obs, idx(k)];
        end
    end 
    delete(m);
    delete(g);
    if isempty(fringe)
        display('No valid path found!');
        return;
    end
    fringe = sortrows(fringe',4)';
    current = fringe(1:2,1);
    visited = [visited,[current;fringe(3,1);fringe(5,1)]];
    heading = fringe(6,1);
    fringe(:,1) = [];
    nodes(:,[delete_unvisited,unfeasible_obs,unfeasible_zone_index]) = [];
    iteration_count = iteration_count + 1;
    fprintf('Current iteration: %d, Current cost: %.2f\n',iteration_count,visited(4,end));
end
fprintf('\nRoadmap generated!\nIterations:%d\nCost of path (time):%.2f seconds\n',iteration_count,visited(4,end));
generate_path(visited,vel,turn_rate,'r');
    
end

