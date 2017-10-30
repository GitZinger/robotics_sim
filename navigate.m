function [rwv,lwv,segment] = navigate(x,y,theta,d,r,mwv,k,tinc,segment,course)
% Handles navigation function selection for robot.  Input arguments
% include inputs that may be used for a navigation function.
%
% INPUT
% [x,y]   : global x,y coordinate of robot
% theta   : global theta of robot (direction robot is facing)
% mwv     : max velocity wheels can turn (rad/s)
% k       : time step index
% tinc    : time increment between time steps
% segment : optional parameter for hard-coding robot navigation
% course  : course object needed if function requires logic grid/nav points
%           grid = course.getGrid()
%           navPoints = course.getNavPoints()
%
% OUTPUT
% rwv     : right wheel velocity, rad/s
% lwv     : left wheel velocity, rad/s
% segment : optional parameter for hard-coding robot navigatoin
%

% Select Navigation Function
% [rwv, lwv, segment] =...
%         avoid_with_spin(x,y,theta,segment,k,mwv,tinc);

%% Path Planning / Motion Control Combinations

% Select Path Planning Function
if(segment == 1)
    course.setPath(A_star_path(course,course.getGrid()));
    segment = 2;
end

% Select Motion Control Algorithm
[rwv, lwv, segment] =...
        pursuit(x,y,theta,k,d,r,mwv,tinc,course,segment);
    
end

