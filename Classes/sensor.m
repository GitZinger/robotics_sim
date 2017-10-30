classdef sensor < handle
    % block: object to be added to course as an obstacle
    
    properties (Access = private)
        Theta
        ObjectD
    end
    
    methods        
        % Constructor
        function obj = sensor(theta)
           obj.Theta = theta;
        end
        
        % Get object theta
        function T = getTheta(obj)
            T = obj.Theta;
        end
        
        % Set object distance
        function setDistance(obj, objectD)
            obj.ObjectD = objectD;
        end
        
        % Get object distance
        function objectD = getDistance(obj)
            objectD = obj.ObjectD;
        end
    end
    
end

