function [] = plot_state_space(dimensions,start,goal,obs,zone)
    figure(1);
    a=plot(start(1),start(2),'ro');
    hold on;
    b=plot(goal(1),goal(2),'rx');

    c = plot_circle(obs(:,1),'b');
    for i=2:size(obs,2);
        plot_circle(obs(:,i),'b');
    end

    d=plot_circle(zone(:,1),'g');
    for i=2:size(zone,2)
        plot_circle(zone(:,i),'g');
    end

    title('UAV Engine-Out Path', 'fontweight', 'bold');
    xlabel('x(m)', 'fontweight', 'bold');
    ylabel('y(m)', 'fontweight', 'bold');
    %legend([a,b,c,d],{'start','goal','obs','safety'},'location','southeast');
    axis(dimensions);
    grid on;

end

