function valid = edge_test(node1,node2,obs)
    global obsCount;
    obsCount = obsCount + 1;
    obst = obs(1:2,:);
    radius = obs(3,:);
    for i = 1 : size(obst,2)
        
        d = (node2-node1);
        f = node1-obst(:,i);
        a = dot(d,d);
        b = 2*dot(f,d);
        c = dot(f,f)-radius(i)^2;
        discrim = b^2-4*a*c;
        
        if discrim < 0
           continue;
        end
        
        t1 = (-b+sqrt(discrim))/2/a;
        t2 = (-b-sqrt(discrim))/2/a;
        if t1>=0 && t1 <=1
            valid = 0;
            return;
        elseif t2>=0 && t2<=1
            valid = 0;
            return;
        elseif t1<=0 && t2>1
            valid = 0;
            return;
        end
        
    end
    valid = 1;
end

