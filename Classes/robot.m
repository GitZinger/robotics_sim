classdef robot < handle
    % robot:
    
    properties (Access = protected)
        Length;
        Width;
        XTrue;
        YTrue;
        XEstimate;
        YEstimate;
        Theta;
        Sensors;
        SensorPlots;
        DistanceTraveled;
    end
    
    methods
        
        % Constructor
        function obj = robot(height,width,XTrue,YTrue,theta,sensorThetas)
           obj.Length = height;
           obj.Width = width;
           obj.XTrue = XTrue;
           obj.YTrue = YTrue;
           obj.XEstimate = XTrue;
           obj.YEstimate = YTrue;
           obj.Theta = theta;
           for s = sensorThetas
            obj.addSensor(sensor(s));
           end
           obj.SensorPlots = [];
           obj.DistanceTraveled = 0;
        end
        
        % Draw robot
        function robImage = draw(obj)
            xc = obj.XTrue(end);
            yc = obj.YTrue(end);
            
            % X,Y vectors to add
            x = [-obj.Length/2 -obj.Length/2 obj.Length/2 obj.Length/2];
            y = [-obj.Width/2 obj.Width/2 obj.Width/2 -obj.Width/2];
            
            % Graphics Theta
            thetaG = obj.Theta(end);
            
            robImage = patch(xc + cos(thetaG)*x - sin(thetaG)*y, ...
                yc + sin(thetaG)*x + cos(thetaG)*y, ...
                'blue');            
        end
        
        % Sense
        function sense(obj,course,sNoise,showSensors)
                        
            obstacles = course.getObstacles();
            courseCoords = course.getCourseCoords();
            X = obj.XTrue(end);
            Y = obj.YTrue(end);
            robPos = [X; Y];
            
            if(showSensors > 0)
                delete(obj.SensorPlots)
                hold on;
                obj.SensorPlots = scatter(X,Y,25,'y','filled');
            end
            
            for s = obj.Sensors
                totalTheta = obj.Theta(end) + s.getTheta();
                maxL = sqrt(sum((courseCoords(1,:)-courseCoords(3,:)).^2));
                sensorCoords = [X Y;X + maxL*cos(totalTheta)...
                    Y+maxL*sin(totalTheta)];
                
                % Initialize sensors to be wall distance values
                checkPt = poly2poly(sensorCoords', courseCoords');
                disWall = sqrt(sum((checkPt(:,1) - robPos).^2));
                intersect = checkPt(:,1);
                for p = 2:size(checkPt,2)
                    d = sqrt(sum((checkPt(:,p) - robPos).^2));
                    if(d < disWall)
                        intersect = checkPt(:,p);
                        disWall = d;
                    end
                end
                s.setDistance(disWall)
                
                % Check all objects
                for o = obstacles
                    checkPt = poly2poly(sensorCoords', o.getCoord()');
                    for p = 1:size(checkPt,2)
                        d = sqrt(sum((checkPt(:,p) - robPos).^2));
                        if(d < s.getDistance())
                            intersect = checkPt(:,p);
                            s.setDistance(d);
                        end
                    end
                end
                
                if(sNoise > 0)
                    s.setDistance(s.getDistance + (2*rand-1)*sNoise);
                end
                
                if(showSensors > 0)
                    obj.SensorPlots = [obj.SensorPlots plot([X,intersect(1)],[Y,intersect(2)], 'y', 'LineWidth', 2)];
                    obj.SensorPlots = [obj.SensorPlots scatter(intersect(1),intersect(2),50,'r','filled')];
                end
            end
            
            
            hold off
        end
    
        % Add sensor
        function addSensor(obj,sensor)
            obj.Sensors = [obj.Sensors sensor];
        end
        
        
        % Get coordinates
        function [coord] = getCoord(obj)
            X = obj.XTrue(end);
            Y = obj.YTrue(end);
            T = obj.Theta(end);
            W = obj.Width;
            L = obj.Length;
            
            coord(1,:)= [X + ( L / 2 ) * cos(T)...
                + ( W / 2 ) * sin(T) ,...
                Y - ( W / 2 ) * cos(T)...
                + ( L / 2 ) * sin(T)];
            coord(2,:)= [X + ( L / 2 ) * cos(T)...
                - ( W / 2 ) * sin(T) ,...
                Y + ( W / 2 ) * cos(T)...
                + ( L / 2 ) * sin(T)];
            coord(3,:)= [X - ( L / 2 ) * cos(T)...
                - ( W / 2 ) * sin(T) ,...
                Y + ( W / 2 ) * cos(T)...
                - ( L / 2 ) * sin(T)];
            coord(4,:)= [X - ( L / 2 ) * cos(T)...
                + ( W / 2 ) * sin(T) ,...
                Y - ( W / 2 ) * cos(T)...
                - ( L / 2 ) * sin(T)];
        end
        
        % Get Theta
        function theta = getTheta(obj,varargin)
            if(nargin==2)
                theta = obj.Theta(cell2mat(varargin(1)));
            else
               theta = obj.Theta; 
            end
        end

        % Get XTrue
        function x = getX(obj,varargin)
            if(nargin==2)
                x = obj.XTrue(cell2mat(varargin(1)));
            else
               x = obj.XTrue; 
            end
        end
        
        % Get YTrue
        function y = getY(obj,varargin)
            if(nargin==2)
                y = obj.YTrue(cell2mat(varargin(1)));
            else
               y = obj.YTrue; 
            end
        end

        % Get XEstimate
        function x = getXEstimate(obj,varargin)
            if(nargin==2)
                x = obj.XEstimate(cell2mat(varargin(1)));
            else
               x = obj.XEstimate; 
            end
        end
        
        % Get YEstimate
        function y = getYEstimate(obj,varargin)
            if(nargin==2)
                y = obj.YEstimate(cell2mat(varargin(1)));
            else
               y = obj.YEstimate; 
            end
        end

        % Set X,Y Estimate
        function setEstimatePosition(obj,x,y,k)
            obj.XEstimate(k) = x;
            obj.YEstimate(k) = y;
        end
        
        % Get W
        function w = getW(obj)
            w = obj.Width;
        end
        
        % Get L
        function l = getL(obj)
            l = obj.Length;
        end
        
        % Get D
        function d = getD(obj)
            d = obj.DistanceTraveled;
        end

    end
    
end

