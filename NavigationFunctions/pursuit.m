function [rwv, lwv, segment] =...
        pursuit(x,y,theta,k,d,r,mwv,tinc,course,segment)

% Constants
thetaT = pi/180;
MOE = 0.5;

w = course.getWayPoint(segment);
dx = w(1)-x;
dy = w(2)-y;
if(sqrt(dx^2+dy^2) < MOE)
    segment = segment + 1;
    w = course.getWayPoint(segment);
    dx = w(1) - x;
    dy = w(2) - y;
end
targetTheta = atan(dy/dx);
if(dx < 0)
    targetTheta = targetTheta + pi;
end

turnSpeed = max((pi/180)/(tinc),abs(theta-targetTheta));

if(abs(theta - targetTheta) > thetaT)
    if (targetTheta > theta)
        rwv = min(mwv,turnSpeed); lwv = -min(mwv,turnSpeed); %spin in place CW
    else
        rwv = -min(mwv,turnSpeed); lwv = min(mwv,turnSpeed); %spin in place DCW
    end
else
    rwv = mwv; lwv = mwv; %full speed ahead
end

end
