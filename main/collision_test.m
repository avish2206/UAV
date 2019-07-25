function valid = collision_test(node,obs)
    for i = 1 : length(obs)
       if (node(1)-obs(1,i))^2 + (node(2)-obs(2,i))^2 <= obs(3,i)^2
          valid = 0;
          return;
       end
    end
    valid = 1;
end

