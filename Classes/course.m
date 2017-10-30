classdef course < handle
    % course: course to be navigated by Robot, containing
    %     obstacles and start/finish points
    
    properties (Access = private)
        Obstacles        % Obstacles to be navigated through
        NavPoints        % Points robot must navigate to
        %     first = start, last = finish
        Length           % Course length, in units
        Width            % Course width, in units
        GFigure          % Figure for game
        RobotPlot        % Holds plot of robot
        LogicGrid        % logic grid of possible robot movements
        Path             % Save path
    end
    
    methods
        % Constructor
        function obj = course(varargin)
            obj.Length = cell2mat(varargin(1));
            obj.Width = cell2mat(varargin(2));
            if(nargin > 3)
                obstacleCell = varargin(3);
                obj.Obstacles = obstacleCell{1};
                navCell = varargin(4);
                obj.NavPoints = navCell{1};
            elseif(nargin > 2)
                obstacleCell = varargin(3);
                obj.Obstacles = obstacleCell{1};
                obj.NavPoints = [[1.5,obj.Length/2];[obj.Width-1.5,obj.Length/2]];
            else
                obj.Obstacles = [];
                obj.NavPoints = [[0,0];[0,0]];
            end
            obj.LogicGrid = [];
        end
        
        % Add obstacle(s)
        function addObstacle(obj, obstacle)
            obj.Obstacles = [obj.Obstacles obstacle];
        end
        
        % Draw course
        function drawCourse(obj)
            % Construct figure
            screensize = get(0,'ScreenSize');
            sz = [screensize(4)*0.8 screensize(3)*0.8];
            xpos = ceil((screensize(3)-sz(2))/2);
            ypos = ceil((screensize(4)-sz(1))/2);
            obj.GFigure = figure('Position',[xpos,ypos,sz(2),sz(1)]);
            set(obj.GFigure, 'MenuBar', 'none');
            set(obj.GFigure, 'ToolBar', 'none');
            set(obj.GFigure,'Color',[0 0 0])
            set(obj.GFigure,'defaultAxesColorOrder',[[1 1 1];[1 1 1]]);
            
            % Modify axis properties
            ax = gca;
            ax.Position = [0.05 0.05 0.9 0.9];
            ax.FontWeight = 'bold';
            ax.FontSize = ax.FontSize*1.5;
            ax.XColor = [1 1 1];
            ax.YColor = [1 1 1];
            xlim([0 obj.Width])
            ylim([0 obj.Length])
            set(gca,'XTick',0:obj.Width/5:obj.Width);
            set(gca,'YTick',0:obj.Length/5:obj.Length);
            set(gca,'XTickLabel',num2cell(0:obj.Width/5:obj.Width));
            set(gca,'YTickLabel',0:obj.Length/5:obj.Length);
            
            % Hold axis properties
            hold on
            
            % Add navpoints
            numP = size(obj.NavPoints,2);
            for p = 1:numP
                drawNav(obj.NavPoints(p,1),...
                    obj.NavPoints(p,2));
            end
            
            % Add obstacles
            for blc = obj.Obstacles
                blc.draw();
            end
            
            % Draw
            drawnow;
            hold off;
        end
        
        % Draw robot(s)
        function drawRobot(obj, robots)
            hold on;
            
            % Delete previous robot plot(s)
            delete(obj.RobotPlot)
            
            % Get number of robots
            numBots = size(robots,2);
            
            % Add robots
            for r = 1:numBots
                rob = robots(r);
                obj.RobotPlot(r) = rob.draw();
            end
            
            % Draw
            drawnow;
            hold off;
        end
        
        % Check move for collisions and goal
        function [goalflag, crashflag] = checkMove(obj,rob,MOE)
            hold on
            xd = rob.getX(end)-obj.NavPoints(end,1);
            yd = rob.getY(end)-obj.NavPoints(end,2);
            if(sqrt(xd^2+yd^2) < MOE)
                goalflag = 1;
                xl = 12/100*obj.Width;
                yl = 4/60*obj.Length;
                xs = (obj.Width/2 - xl);
                ys = (3*obj.Length/4 - yl);
                pos = [xs ys 2*xl 2*yl];
                rectangle('Position',pos,'FaceColor','white','EdgeColor','blue')
                label = sprintf('SUCESS');
                text(obj.Width/2,3*obj.Length/4,label,'FontSize',50,...
                    'FontWeight','bold','Color','blue','HorizontalAlignment',...
                    'center')
                
                xl = 12/100*obj.Width;
                yl2 = 1/60*obj.Length;
                xs = (obj.Width/2 - xl);
                ys = (3*obj.Length/4 - 2*yl - yl2);
                pos = [xs ys 2*xl 2*yl2];
                rectangle('Position',pos,'FaceColor','white','EdgeColor','white')
                label = sprintf('Distance: %.2f',rob.getD());
                text(obj.Width/2,3*obj.Length/4-2*yl,label,'FontSize',20,...
                    'FontWeight','bold','Color','blue','HorizontalAlignment',...
                    'center')
            else
                goalflag = -1;
            end
            
            crashflag = -1;
            % seperating axis theorem
            for bloc = obj.Obstacles
                if(sat(rob.getCoord(),bloc.getCoord()) == 1)
                    crashflag = 1;
                    xl = 12/100*obj.Width;
                yl = 4/60*obj.Length;
                    xs = (obj.Width/2 - xl);
                    ys = (3*obj.Length/4 - yl);
                    pos = [xs ys 2*xl 2*yl];
                    rectangle('Position',pos,'FaceColor','white','EdgeColor','red')
                    label = sprintf('FAILURE');
                    text(obj.Width/2,3*obj.Length/4,label,'FontSize',50,...
                        'FontWeight','bold','Color','red','HorizontalAlignment',...
                        'center')
                end
            end
            
            hold off
        end
        
        % Create Logic Grid
        function createGrid(obj,gridSize,rob)
            
            % Initialize grid to zeros
            grid = zeros(ceil(obj.Width/gridSize),ceil(obj.Length/gridSize));
            
            % Account for robot size in grid
            bumper = ceil(rob.getW()/(2*gridSize));
            for bloc = obj.Obstacles
                bcoord = bloc.getCoord();
                xs = max(floor(min(bcoord(:,1))/gridSize)-bumper,1);
                xf = min(ceil(max(bcoord(:,1))/gridSize)+bumper,obj.Width/gridSize);
                ys = max(floor(min(bcoord(:,2))/gridSize)-bumper,1);
                yf = min(ceil(max(bcoord(:,2))/gridSize)+bumper,obj.Length/gridSize);
                grid(xs:xf,ys:yf) = ...
                    ones(xf-xs+1,yf-ys+1);
            end
            
            obj.LogicGrid = grid;
        end
        
        % Get logic Grid
        function grid = getGrid(obj)
            grid = obj.LogicGrid;
        end
        
        % Get Path
        function path = getPath(obj)
            path = obj.Path;
        end
        
        % Set Path
        function setPath(obj,path)
            obj.Path = path;
        end
        
        % Get WayPoint
        function p = getWayPoint(obj,segment)
            n = size(obj.Path,1);
            p = obj.Path(n-segment+1,:);
        end
            
        
        % Get navigation points
        function navPoints = getNavPoints(obj)
            navPoints = obj.NavPoints;
        end
        
        % Get obstacles
        function obstacles = getObstacles(obj)
            obstacles = obj.Obstacles;
        end
        
        function courseCoords = getCourseCoords(obj)
            courseCoords = [0 0; obj.Width 0;...
                obj.Width obj.Length; 0 obj.Length];
        end
        
        % Get W
        function w = getW(obj)
            w = obj.Width;
        end
        
        % Get L
        function l = getL(obj)
            l = obj.Length;
        end
        
    end
    
end

% Draw navPoint
function graphics = drawNav(x,y,graphics)
W = 3;
L = 3;
xs = x - W/2;
ys = y - L/2;
pos = [xs ys W L];
rectangle('Position',pos,'Curvature',[1 1],'FaceColor','red','EdgeColor','black')
end
