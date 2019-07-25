%% main.m - main code for thesis
% path generation for uav from start to goal incorporating obstacle
% avoidance and time constraints dictated by the un-powered uav descent
% to a pre-defined safety zone, in case of an emergency landing.

clc;
clear;
close all;

%% Global variables
global path_count;
global obsCount; % total obstacle count
global pathreconstruction; % flag for implementing path reconstruction algorithm
global obstaclecluster; %flag for implementing obstacle cluster algorithm
path_count = 0;
obsCount = 0;
a = input('Implement path reconstruction algorithm? (y/n): ','s');
if a== 'y'
    pathreconstruction = 1;
else
    pathreconstruction = 0;
end
a = input('Implement obstacle cluster algorithm? (y/n): ','s');
if a=='y'
    obstaclecluster = 1;
else
    obstaclecluster = 0;
end

%% Define grid
width = 1000;
height = 1000;
dimensions = [0 width 0 height];

%% Start and goal positions
start = [100;100];
goal  = [900;900];
dimensions2 = [start(1) goal(1) start(2) goal(2)];

%% Safety zones
radius_safety = 30;
zone1 = [100;300;radius_safety];
zone2 = [300;800;radius_safety];
zone3 = [650;900;radius_safety];
zone = [zone1,zone2,zone3];

%% Obstacles
while true
    a = input('Generate random obstacle space? (y/n): ','s');
    if a=='y'
        no_obs = 10;
        min_radius = 50;
        max_radius = 70;
        obs = create_obstacle_space(no_obs,dimensions2,min_radius,max_radius,zone);
        break;
    elseif a=='n'
        b = input('Enter name of obstacle .mat file: ','s');
        load(b);
        break;
    else
        display('Incorrect input! Press any key and try again.');
    end
end

%% Plotting
plot_state_space(dimensions,start,goal,obs,zone);

%% Vehicle parameters
descent_time   = 40;
velocity       = 10;
init_heading   = 0;
turn_rate      = 90*pi/180;

%% Sample parameters
npoints = 1000;
range_search = 100;

%% Cluster parameters
cluster_range = range_search;

%% Wind parameters
type = 'const';
if strcmp(type,'const')
    vector = [0,0];
elseif strcmp(type,'var')
    vector = [];
end

%% Setup param structure
param.uav.start = start;
param.uav.goal  = goal;
param.uav.descent_time = descent_time;
param.uav.velocity = velocity;
param.uav.init_heading = init_heading;
param.uav.turn_rate = turn_rate;
param.space.obs = obs;
param.space.zone = zone;
param.sample.npoints = npoints;
param.sample.range = range_search;
param.cluster.range = cluster_range;
param.wind.type = type;
param.wind.vector = vector;

%% main section
display('State space shown in Figure 1. Press any key to start algorithm.');
pause();
tic;
path = dynamic_roadmap2(param);
save 'path_var_wind.mat' 'path';
plot1 = plot(path(1,:),path(2,:),'r','linewidth',2);
load('path_no_wind.mat');
plot2 = plot(path(1,:),path(2,:),'k--','linewidth',2);
legend([plot1,plot2],{'Wind Field', 'No Wind Field'});
time = toc;
fprintf('\nRuntime to generate path: %.2f seconds\n',time);
fprintf('Total collision checks  : %d\n', obsCount);   

