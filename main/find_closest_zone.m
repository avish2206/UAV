function [cost,index] = find_closest_zone(node,zone,wind,vel,heading,turn_rate)
    cost = inf;
    index = 0;
    for i = 1 : size(zone,2)
        dist = norm(node-zone(1:2,i))-zone(3,i);
        turn_cost = calculate_turn_cost(node,zone(1:2,i),heading,turn_rate);
        vel = vel + calculate_projection(node,zone(1:2,i),wind);
        temp_cost = dist/vel + turn_cost;
        if temp_cost < cost
            cost = temp_cost;
            index = i;
        end
    end
end

