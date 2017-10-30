% Script To Create and Save Robot Course

% Name of Course
courseName = 'Track 1';

% Course Parameters
length = 60;    % Length of course (Y axis)
width = 100;     % Width of Course (X axis)


%% Add Navpoints to course
xs = 5*2;
ys = 15*2;
xf = 45*2;
yf = 15*2;
navPoints = [xs ys; xf yf];

%% Add Obstacles to course
% Add Block left
blH = 30*2;
blW = 2;
blX = 0;
blY = 15*2;
obstacles = block(blH,blW,blX,blY);

% Add Block right
blH = 30*2;
blW = 2;
blX = 50*2;
blY = 15*2;
obstacles = [obstacles block(blH,blW,blX,blY)];

% Add Block top
blH = 2;
blW = 50*2;
blX = 25*2;
blY = 30*2;
obstacles = [obstacles block(blH,blW,blX,blY)];

% Add Block bottom
blH = 2;
blW = 50*2;
blX = 25*2;
blY = 0;
obstacles = [obstacles block(blH,blW,blX,blY)];


% % Add Block
% blH = 6;
% blW = 6;
% blX = 50;
% blY = 30;
% obstacles = [obstacles block(blH,blW,blX,blY)];

% % Add Block
% blH = 2;
% blW = 30;
% blX = 39;
% blY = 19;
% obstacles = [obstacles block(blH,blW,blX,blY)];
% 
% % Add Block
% blH = 2;
% blW = 20;
% blX = 90;
% blY = 25;
% obstacles = [obstacles block(blH,blW,blX,blY)];
% 
% % Add Block
% blH = 20;
% blW = 2;
% blX = 79;
% blY = 34;
% obstacles = [obstacles block(blH,blW,blX,blY)];
% 
% % Add Block
% blH = 2;
% blW = 20;
% blX = 68;
% blY = 43;
% obstacles = [obstacles block(blH,blW,blX,blY)];
% 
% % Add Block
% blH = 8;
% blW = 2;
% blX = 53;
% blY = 16;
% obstacles = [obstacles block(blH,blW,blX,blY)];
% 
% % Add Block
% blH = 2;
% blW = 14;
% blX = 61;
% blY = 13;
% obstacles = [obstacles block(blH,blW,blX,blY)];


% Add random blocks
maxB = 10;
for b = 1:maxB/2
    blH = round(rand*50);
    blY = round(rand*(length - blH) + blH/2);
    blW = round(2);
    blX = round(rand*(width-blW) + blW/2);
    obstacles = [obstacles block(blH,blW,blX,blY)];
end
for b = 1:maxB/2
    blH = round(2);
    blY = round(rand*(length - blH) + blH/2);
    blW = round(rand*50);
    blX = round(rand*(width-blW) + blW/2);
    obstacles = [obstacles block(blH,blW,blX,blY)];
end


%% Create and save course
track = course(length,width,obstacles,navPoints);
courseFileName = strcat('Courses/',courseName);
save(courseFileName,'track')
track.drawCourse();