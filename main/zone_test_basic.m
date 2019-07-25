function [is_valid,index,total_cost] = zone_test_basic(node,param,heading,turn_rate)

threshold = param.uav.descent_time;
zone = param.space.zone;
wind = param.wind;
vel = param.uav.velocity;
[total_cost,index] = find_closest_zone(node,zone,wind,vel,heading,turn_rate);
if total_cost < threshold
    is_valid = 1;
    return;
end
is_valid = 0;

end

