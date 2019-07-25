%% main.m - main code for thesis
% path generation for uav from start to goal incorporating obstacle
% avoidance and time constraints dictated by the un-powered uav descent
% to a pre-defined safety zone, in case of an emergency landing.

clc;
clear;
close all;

%% Define grid
figure(1);
width = 1000;
height = 1000;
altitude = 100;
dimensions = [0 width 0 height 0 altitude];

%% Start and goal positions
start = [100;100;altitude];
goal  = [900;900;altitude];

%% Obstacles
radius_obstacle = 50;
obs1 = [450;350];
obs2 = [300;550];
obs3 = [650;650];
obs4 = [500;800];

%% Safety zones
radius_safety = 30;
zone1 = [100;500];
zone2 = [300;800];
zone3 = [700;300];

%% Plotting
figure(1);
a=plot3(start(1),start(2),start(3),'ro','linewidth',2);
hold on;
b=plot3(goal(1),goal(2),goal(3),'rx','linewidth',2);

[xc,yc,zc] = cylinder;
surf(xc*radius_obstacle+obs1(1),yc*radius_obstacle+obs1(2),zc*altitude,'FaceColor','blue','LineStyle','none','FaceAlpha',0.5);
surf(xc*radius_obstacle+obs2(1),yc*radius_obstacle+obs2(2),zc*altitude,'FaceColor','blue','LineStyle','none','FaceAlpha',0.5);
surf(xc*radius_obstacle+obs3(1),yc*radius_obstacle+obs3(2),zc*altitude,'FaceColor','blue','LineStyle','none','FaceAlpha',0.5);
surf(xc*radius_obstacle+obs4(1),yc*radius_obstacle+obs4(2),zc*altitude,'FaceColor','blue','LineStyle','none','FaceAlpha',0.5);
c=plot_circle(obs1,radius_obstacle,'b');
plot_circle(obs2,radius_obstacle,'b');
plot_circle(obs3,radius_obstacle,'b');
plot_circle(obs4,radius_obstacle,'b');
d=plot_circle(zone1,radius_safety,'g');
plot_circle(zone2,radius_safety,'g');
plot_circle(zone3,radius_safety,'g');

%title('UAV Engine-Out Path', 'fontweight', 'bold');
xlabel('x(m)', 'fontweight', 'bold');
ylabel('y(m)', 'fontweight', 'bold');
zlabel('z(m)', 'fontweight', 'bold');
legend([a,b,c,d],{'start','goal','obs','safety'});
axis(dimensions);
grid on;

% figure(1);
% a=plot(start(1),start(2),'ro');
% hold on;
% b=plot(goal(1),goal(2),'rx');
% 
% c=plot_circle(obs1,radius_obstacle,'b');
% plot_circle(obs2,radius_obstacle,'b');
% plot_circle(obs3,radius_obstacle,'b');
% plot_circle(obs4,radius_obstacle,'b');
% d=plot_circle(zone1,radius_safety,'g');
% plot_circle(zone2,radius_safety,'g');
% plot_circle(zone3,radius_safety,'g');
% 
% %title('UAV Engine-Out Path', 'fontweight', 'bold');
% xlabel('x(m)', 'fontweight', 'bold');
% ylabel('y(m)', 'fontweight', 'bold');
% legend([a,b,c,d],{'start','goal','obs','safety'});
% axis(dimensions);
% grid on;

%% Vehicle parameters
altitude = 100;
forward_velocity = 3.5;
descent_velocity = 10;
landing_time = altitude/descent_velocity;

%% Sample points
npoints = 100;
k = 3;
%generate_roadmap_test(npoints,start,goal,forward_velocity,landing_time,k);

