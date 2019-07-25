function projection = calculate_projection(node1,node2,wind_struct)
    path = node2-node1;
    type = wind_struct.type;
    path_magnitude = norm(path);
    if path_magnitude == 0
        projection = 0;
        return;
    end
    
    if strcmp(type,'const')
        wind = wind_struct.vector;
        wind_magnitude = norm(wind);
        if wind_magnitude == 0
            projection = 0;
            return;
        end
        cos_theta = dot(path,wind) / (path_magnitude * wind_magnitude);
        projection = wind_magnitude * cos_theta;
    else
        wind1 = [1,1];
        wind1_magnitude = norm(wind1);
        wind2 = [1,1.5];
        wind2_magnitude = norm(wind2);
       % DEFINE GRIDS
       % GRID 1: 300<x<500, 400<y<550 -> xwind = -1, ywind = -1
       % GRID 2: 300<x<500, 550<y<700 -> xwind = 1, ywind = 1.5
%        if ((node1(1)<300 && node2(1)<300) || (node1(2)<400 && node2(2)<400) || ...
%           (node1(1)>500 && node2(1)>500) || (node1(2)>700 && node2(2)>700))
%             display('not in grid');
%             projection = 0;
%             return;
%        end
%        
%        if node2(2) < 550
%             cos_theta = dot(path,wind1) / (path_magnitude * wind1_magnitude);
%             projection = wind1_magnitude * cos_theta;
%        else
%            cos_theta = dot(path,wind2) / (path_magnitude * wind2_magnitude);
%            projection = wind2_magnitude * cos_theta;
%        end
        if node2(2) > 600
            cos_theta = dot(path,wind1) / (path_magnitude * wind1_magnitude);
            projection = wind1_magnitude * cos_theta; 
        else
            projection = 0;     
        end
        
    end
end

