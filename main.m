%% Main Driver for robot Simuation Project
%
% James Smith
%
%% User Input

% Prepare Workspace
clear all; close all;
prepareWorkspace();

% Load Course
load('Track 3.mat')

% Simulation Settings
tmax = 2000;        % max. simulation time
tinc= 1;        % simulation timestep
MOE = 0.5;        % margin of error for robot goal 
showSensors = 1; % > 0 plots sensors
sNoise = 0;       % max magnitude of random noise added to sensor values
gridSize = 1;     % <= 0, no navigation grid is created

% DD Robot Settings
r=.01;        % wheel radius
l=.05;        % half the axle track
mv = 1;      % maximum wheel vel in m/s
theta = 0;    % inital value of theta (angle between global & local coord sys.)
rL = 5;       % robot length
rW = 3;       % robot width
sensorT = 0:pi/4:15*pi/8; % sensor locations

% Movie Settings
willRecord = -1;   % > 0 record movie
movieName = 'Movie 3 with sensors';

%% Inititialzatoin/Paramteter Proccessing

% Robot
mwv = mv / r; % covert to rad/s
navPoints = track.getNavPoints();
rX = navPoints(1,1);      % initial robot global x for center of robot
rY = navPoints(1,2);      % initial robot global y for center of robot
rob = ddrobot(rL,rW,rX,rY,theta,sensorT,r,l,mwv);

% Course
track.drawCourse();
if(gridSize > 0)
    track.createGrid(gridSize,rob);
end

% Simulation
kmax = tmax/tinc;   % Index for time step must be integer
goalflag = -1;      % initialize goal flag
crashflag = -1;     % initialize crash flag
segment = 1;        % optional parameter for hard-coding robot navigation

%% Simulation

% time step index
k = 1;

% draw robot
track.drawRobot(rob);

% get sensor values
rob.sense(track,sNoise,showSensors);

% localization
[x_est,y_est] = localize(rob,k);
rob.setEstimatePosition(x_est,y_est,k);

% get initial wheel velocities
[phi1dot, phi2dot, segment] =...
    navigate(rob.getX(k),rob.getY(k),rob.getTheta(k),rob.getWL()*2,r,mwv,k,tinc,segment,track);
rob.setPhidot(phi1dot,phi2dot);

% record movie
if(willRecord > 0)
    videoName = strcat('Movies/',movieName,'.avi');
    v = VideoWriter(videoName);
    open(v);
    frame = getframe(gcf);
    writeVideo(v,frame);
end

for k=2:kmax
    % get time step
    t = k*tinc;
    
    % move robot
    rob.move(k,tinc);
    [goalflag, crashflag] = track.checkMove(rob,MOE);
    
    % draw robot 
    track.drawRobot(rob);
    
    if(crashflag>0)
        break
    elseif(goalflag>0)
        break
    end
    
    % get sensor values
    rob.sense(track,sNoise,showSensors);
    
    % localization
    [x_est,y_est] = localize(rob,k);
    rob.setEstimatePosition(x_est,y_est,k);
    
    % get new wheel velocities
    [phi1dot, phi2dot, segment] =...
        navigate(rob.getX(k),rob.getY(k),rob.getTheta(k),rob.getWL()*2,r,mwv,k,tinc,segment,track);
rob.setPhidot(phi1dot,phi2dot);
    
    % record movie
    if(willRecord > 0)
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
end

% save movie
% get frame
if(willRecord > 0)
    frame = getframe(gcf);
    writeVideo(v,frame);
    close(v);
end
