function turn_cost = calculate_turn_cost(current,node,heading,turn_rate)
    new_heading = calculate_new_heading(current,node);
    
    heading_change = calculate_heading_change(heading,new_heading);
    
    turn_cost = heading_change/turn_rate;
end

