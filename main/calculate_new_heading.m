function [new_heading] = calculate_new_heading(node1,node2)

new_heading = atan2(node2(2)-node1(2),node2(1)-node1(1));
if new_heading < 0
    new_heading = new_heading + 2*pi;
end

end

