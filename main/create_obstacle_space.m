function obs = create_obstacle_space(no_obs,dimensions,min_radius,max_radius,zone)
    obs = zeros(3,no_obs);
    for i = 1 : no_obs
        while true
            xcentre = dimensions(1) + (dimensions(2)-dimensions(1))*abs(rand(1));
            ycentre = dimensions(3) + (dimensions(4)-dimensions(3))*abs(rand(1));
            radius  = min_radius + (max_radius-min_radius)*abs(rand(1));
            circle = [xcentre;ycentre;radius];
            if obstacle_position_test(circle,zone)
                break;
            end
        end
        obs(:,i) = circle;
    end
end

