function [rwv, lwv, segment] =...
        template(x,y,theta,segment,k,mwv,tinc)
% REWRITE THE FOLLOWING CODE AS NEEDED FOR THE REQUIRED TRAJECTORY

% Constants
turnDeg = 25*pi/180;
turnSpeed = (pi/8)/(2*tinc);
xo = 25;

switch segment
    
    case 1
        if (theta>-turnDeg)
            rwv = -min(mwv,turnSpeed); lwv = min(mwv,turnSpeed); %spin in place CW
        else
            rwv=mwv;lwv=mwv; %move straight until in line with object
            segment=segment+1;
        end
    case 2
        if (x < xo)
            rwv=mwv;lwv=mwv; %move straight until in line with object
        else
            %Closest location to robot
            rwv = min(mwv,turnSpeed); lwv = -min(mwv,turnSpeed); %rotate CW, face east
            segment = segment+1;
        end
    case 3
        if (theta<turnDeg)
            rwv = min(mwv,turnSpeed); lwv = -min(mwv,turnSpeed); %rotate CW, face east
        else
            rwv=mwv;lwv=mwv; %move straight until reach goal
            segment=segment+1;
        end
    case 4
        rwv=mwv;lwv=mwv; %move straight until reach goal
end
end
