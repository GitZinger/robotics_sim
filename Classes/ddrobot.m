classdef ddrobot < robot
    % robot:
    
    properties (Access = private)
        R;       % wheel radius, meters
        WL;      % 1/2 distance between axle track, meters
        MV;      % maximum wheel velocity, radians per second
        Phi1dot  % right wheel velocity, radians per second
        Phi2dot  % left wheel velocity, radians per second
    end
    
    methods
        
        % Constructor
        function obj = ddrobot(height,width,XTrue,YTrue,theta,sensorT,...
                rad,wheelL,maxV)
           obj@robot(height,width,XTrue,YTrue,theta,sensorT);
           obj.R = rad;
           obj.WL = wheelL;
           obj.MV = maxV;
        end
        
        % Move robot
        function move(obj,k,tinc)
            thetaG = obj.Theta(k-1);
            
            % construct inverse rotation matrix according to Eqn. 3.10
            rthinv=[cos(thetaG) -sin(thetaG) 0; sin(thetaG) cos(thetaG) 0; 0 0 1];
            
            % compute the differential pose in the local ref. frame:
            xsi_R_dot=[obj.R*obj.Phi1dot/2 + obj.R*obj.Phi2dot/2; 0; obj.R*obj.Phi1dot/2/obj.WL - obj.R*obj.Phi2dot/2/obj.WL];
            
            % use Eqn. 3.9 to compute the differential pose in the global ref. frame:
            xsi_I_dot=rthinv*xsi_R_dot;
            
            obj.XTrue(k)=obj.XTrue(k-1)+xsi_I_dot(1)*tinc;   % new global x position
            obj.YTrue(k)=obj.YTrue(k-1)+xsi_I_dot(2)*tinc;   % new global y position
            obj.Theta(k)=obj.Theta(k-1)+xsi_I_dot(3)*tinc; % new value of theta
            
            obj.DistanceTraveled = obj.DistanceTraveled + sqrt((obj.XTrue(k-1) - obj.XTrue(k))^2+(obj.YTrue(k-1) - obj.YTrue(k))^2);
            % plot movement
            hold on
            plot([obj.XTrue(k-1),obj.XTrue(k)],[obj.YTrue(k-1),obj.YTrue(k)], 'b', 'LineWidth', 3)
            hold off
        end
        
        
        % Getters and Setters
        function setPhidot(obj,phi1dot,phi2dot)
            obj.Phi1dot = phi1dot;
            obj.Phi2dot = phi2dot;
        end
        
        % Get wl
        function wl = getWL(obj)
            wl = obj.WL;
        end
    end
    
end

