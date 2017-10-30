function [rwv, lwv, segment] =...
        pure_pursuit(x,y,theta,k,d,r,mwv,tinc,course,segment)

w = course.getWayPoint(segment);
dx = w(1) - x;
dy = w(2) - y;
r = (dx^2 + dy^2) / (2 * dx);

% Curvature
y = 1/r;


rwv = v + (d/2)*w;
lwv = v - (d/2)*w;
end
