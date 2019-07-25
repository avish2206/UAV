function [is_intersect,inodes,ipath] = locate_path_nodes(nodes,path)
    [C,inodes,ipath] = intersect(nodes',path','rows');
    if isempty(C)
        is_intersect = 0;
        return;
    end
    is_intersect = 1;
end

