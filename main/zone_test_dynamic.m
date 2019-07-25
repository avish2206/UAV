function [is_valid,path] = zone_test_dynamic(nodes,start,zone,param,init_heading)

%% unpack parameters
vel = param.uav.velocity;
threshold = param.uav.descent_time;
radius = param.sample.range;
obs = param.space.obs;
turn_rate = param.uav.turn_rate;
wind = param.wind;

%% Define preliminary variables
goal = zone(1:2);
goal_rad = zone(3);
nodes = [goal,nodes];
fringe = [];
current = start;
visited = [current;0;0];
iteration_count = 1;
is_goal = 0;
heading = init_heading;

%% main loop
while ~is_goal
   [idx, D] = rangesearch(nodes', current', radius);
    idx = idx{1};
    D = D{1};
    cost = visited(4,end);
    for k = 1 : length(idx) 
        temp = nodes(:,idx(k));
        new_heading = calculate_new_heading(current,temp);
        if edge_test(current,temp,obs)
            vel_proj = vel + calculate_projection(current,temp,wind);
            T_proj = D(k)/vel_proj;
            turn_time = calculate_turn_cost(current,temp,heading,turn_rate);
            vel_proj = vel + calculate_projection(temp,goal,wind);
            goal_heuristic = norm(temp-goal)/vel_proj + calculate_turn_cost(temp,goal,heading,turn_rate);
            [flag,index] = is_fringe(idx(k),fringe);
            if flag 
                if cost+T_proj+turn_time+goal_heuristic < fringe(4,index)
                    fringe(:,index) = [temp;size(visited,2);cost+T_proj+goal_heuristic+turn_time;cost+T_proj+turn_time;new_heading;idx(k)];
                else
                    continue;
                end
            else
                fringe = [fringe,[temp;size(visited,2);cost+T_proj+goal_heuristic+turn_time;cost+T_proj+turn_time;new_heading;idx(k)]];
            end
        else
            nodes(:,idx(k)) = nan(2,1);
        end
    end 
    if isempty(fringe)
        is_valid = 0;
        path = [];
        return;
    end
    fringe = sortrows(fringe',4)';
    current = fringe(1:2,1);
    remove_index = fringe(end,1);
    visited = [visited,[current;fringe(3,1);fringe(5,1)]];
    heading = fringe(6,1);
    fringe(:,1) = [];
    nodes(:,remove_index) = nan(2,1);
    iteration_count = iteration_count + 1;
    if norm(goal-current)<goal_rad
        is_goal=1;
    end
end

if visited(4,end)<threshold
    path = generate_path(visited,vel,turn_rate,'g',wind);
    is_valid = 1;
else
    is_valid = 0;
    path = [];
end

end

