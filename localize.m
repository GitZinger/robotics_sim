function [x_estimate, y_estimate] = localize(rob,k)
% Handles navigation function selection for robot.  Input arguments
% include inputs that may be used for a navigation function.
%
% INPUT
% rob          : properties include true x,y; global x,y; sensors
% k            : time step index

% OUTPUT
% x_estimate   : estimated x global position
% y_estimate   : estimated y global position

% Select Navigation Function
[x_estimate, y_estimate] =...
        truth_localization(rob.getX(k),rob.getY(k));

end

