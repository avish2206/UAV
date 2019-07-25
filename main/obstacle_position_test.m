function valid = obstacle_position_test(circle,zone)
    for i = 1 : length(zone)
       temp = zone(:,i);
       a = (temp(1)-circle(1))^2;
       b = (temp(2)-circle(2))^2;
       c = (temp(3)+circle(3))^2;
       if a+b<=c
           valid = 0;
           return;
       end
    end
    valid = 1;
end



