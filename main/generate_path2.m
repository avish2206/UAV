function path = generate_path2(nodes,velocity,turn_rate,color,wind)
    global path_count;
    time = 0;
    total_turn = 0;
    current = nodes(:,end);
    index = size(nodes,2);
    iteration = 1;
    path = [current(1:2);0];
    while index~=1
       next_index = current(3);
       next = nodes(:,next_index);
       new_heading = calculate_new_heading(current(1:2),next(1:2));
       if iteration ~= 1
          total_turn = total_turn + calculate_heading_change(heading,new_heading); 
       end
       vel_proj = velocity + calculate_projection(next(1:2),current(1:2),wind);
       dist = norm(next(1:2)-current(1:2));
       time = time + dist/vel_proj;
       path = [path, [next(1:2);time+total_turn/turn_rate]];
       current = next;
       index = next_index;
       heading = new_heading;
       iteration = iteration + 1;
    end
    %h = plot(path(1,:),path(2,:),color,'linewidth',2);
    %delete(h);
%     if path_count==48
%         path_count = path_count + 1;   
%     else
%         %delete(h);
%         path_count = path_count + 1;
%     end
    path_count = path_count + 1;
    %display(path_count);
    %pause();
end