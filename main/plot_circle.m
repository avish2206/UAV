function h = plot_circle(obs,color)
    centre = obs(1:2);
    radius = obs(3);
    theta = 0:0.01:2*pi;
    x = centre(1) + radius*cos(theta);
    y = centre(2) + radius*sin(theta);
    
    
    h=plot(x,y,color,'linewidth',2);
    if color=='g'
        plot(centre(1),centre(2),strcat(color,'x'),'linewidth',2);
    end

end

