function valid = safety_test(node,forward_velocity,landing_time)
    % safety zone 1
    if node(2) <= 45
        time = sqrt(node(1)*node(1)+(45-node(2))*(45-node(2)))/forward_velocity;
    elseif node(2) <= 55
        time = node(1)/forward_velocity;
    else
        time = sqrt(node(1)*node(1)+(55-node(2))*(55-node(2)))/forward_velocity;
    end
    
    if time < landing_time
        valid = 1;
        return;
    end
    
    % safety zone 2
    if node(1) <= 45
        time = sqrt((100-node(2))*(100-node(2))+(45-node(1))*(45-node(1)))/forward_velocity;
    elseif node(1) <= 55
        time = (100-node(2))/forward_velocity;
    else
        time = sqrt((100-node(2))*(100-node(2))+(55-node(1))*(55-node(1)))/forward_velocity;
    end
    
    if time < landing_time
        valid = 1;
        return;
    end
    
    % safety zone 3
    if node(2) <= 45
        time = sqrt((100-node(1))*(100-node(1))+(45-node(2))*(45-node(2)))/forward_velocity;
    elseif node(2) <= 55
        time = (100-node(1))/forward_velocity;
    else
        time = sqrt((100-node(1))*(100-node(1))+(55-node(2))*(55-node(2)))/forward_velocity;
    end
    
    if time < landing_time
        valid = 1;
        return;
    end
    
    % safety zone 4
    if node(1) <= 45
        time = sqrt(node(2)*node(2)+(45-node(1))*(45-node(1)))/forward_velocity;
    elseif node(1) <= 55
        time = node(2)/forward_velocity;
    else
        time = sqrt(node(2)*node(2)+(55-node(1))*(55-node(1)))/forward_velocity;
    end
    
    if time < landing_time
        valid = 1;
        return;
    end
    
    valid = 0;
    
end

