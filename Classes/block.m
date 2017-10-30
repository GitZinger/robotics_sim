classdef block < handle
    % block: object to be added to course as an obstacle
    
    properties (Access = private)
        Length;
        Width;
        XTrue;
        YTrue;
        Theta;
    end
    
    methods        
        % Constructor
        function obj = block(height,width,XTrue,YTrue)
           obj.Length = height;
           obj.Width = width;
           obj.XTrue = XTrue;
           obj.YTrue = YTrue;
           obj.Theta = 0;
        end
        
        % Draw block
        function draw(obj)
            xs = (obj.XTrue - obj.Width/2);
            ys = (obj.YTrue - obj.Length/2);
            pos = [xs ys obj.Width obj.Length];
            rectangle('Position',pos,'FaceColor','green','EdgeColor','black')
        end
        
        function [coord] = getCoord(obj)
            X = obj.XTrue;
            Y = obj.YTrue;
            T = obj.Theta;
            W = obj.Width;
            L = obj.Length;
            
            coord(1,:)= [X + ( W / 2 ) * cos(T)...
                + ( L / 2 ) * sin(T) ,...
                Y - ( L / 2 ) * cos(T)...
                + ( W / 2 ) * sin(T)];
            coord(2,:)= [X + ( W / 2 ) * cos(T)...
                - ( L / 2 ) * sin(T) ,...
                Y + ( L / 2 ) * cos(T)...
                + ( W / 2 ) * sin(T)];
            coord(3,:)= [X - ( W / 2 ) * cos(T)...
                - ( L / 2 ) * sin(T) ,...
                Y + ( L / 2 ) * cos(T)...
                - ( W / 2 ) * sin(T)];
            coord(4,:)= [X - ( W / 2 ) * cos(T)...
                + ( L / 2 ) * sin(T) ,...
                Y - ( L / 2 ) * cos(T)...
                - ( W / 2 ) * sin(T)];
        end
        
        
    end
    
end

