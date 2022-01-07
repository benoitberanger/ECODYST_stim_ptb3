function main()
% Just run this function

clc

project_dir = fileparts(mfilename('fullpath')); % "fileparts" first output is the dir of the input
cd(project_dir); % just to make sure we are in the right dir

fprintf('Project name : %s \n', project_name() );
fprintf('Project path : %s \n', project_dir    );

check_requirements()

fprintf('Starting (or focussing) GUI... \n');

GUI.VIEW.OpenGUI(); % the GUI is the **ONLY** interface the user will interact with

% NOTES:
%
% Here for the GUI I use the Model-View-Controller architecture : https://en.wikipedia.org/wiki/Model-view-controller
% The core program is GUI.MODEL.Core(). This is where everything happens.
% Inside GUI.MODEL.Core(), the program of the task will be called with all the settings comming from the GUI
% Tasks codes are in +TASK/+<task_name>/Runtime.m, and the settings are in +TASK/+<task_name>/Parameters.m
%

end % function
