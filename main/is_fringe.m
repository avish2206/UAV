function [flag,index] = is_fringe(node_index,fringe)
    if isempty(fringe)
        flag = 0;
        index = [];
        return;
    end
    fringe_indices = fringe(end,:);
    index = find(fringe_indices==node_index);
    if isempty(index)
        flag = 0;
    else
        flag = 1;
    end
end

