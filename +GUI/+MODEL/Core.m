function Core( hObject, ~ )
% This is the main program, calling the different tasks and routines,
% accoding to the paramterts defined in the GUI


%% Retrieve GUI data
% I prefere to do it here, once and for all.

handles = guidata( hObject );


%% Clean the environment

clc
sca
rng('default')
rng('shuffle')


%% Initialize the main structure

% NOTES : Here I made the choice of using a "global" variable, because it
% simplifies a lot all the functions. It allows retrieve of the variable
% everywhere, and make lighter the input paramters.

global S
S                 = struct; % S is the main structure, containing everything usefull, and used everywhere
S.TimeStampSimple = datestr(now, 'yyyy-mm-dd HH:MM'); % readable
S.TimeStampFile   = datestr(now, 30                ); % yyyymmddTHHMMSS : to sort automatically by time of creation


%% Lots of get*

S.Task            = GUI.CONTROLLER.getTask         ( hObject );
S.SaveMode        = GUI.CONTROLLER.getSaveMode     ( handles );
S.Environement    = GUI.CONTROLLER.getEnvironement ( handles );
S.OperationMode   = GUI.CONTROLLER.getOperationMode( handles );
S.MovieMode       = GUI.CONTROLLER.getMovieMode    ( handles );
S.ScreenID        = GUI.CONTROLLER.getScreenID     ( handles );
S.WindowedMode    = GUI.CONTROLLER.getWindowedMode ( handles );
S.EyelinkMode     = GUI.CONTROLLER.getEyelinkMode  ( handles );
S.ParPort         = GUI.CONTROLLER.getParPort      ( handles );


%% Subject ID & Run number

[ S.SubjectID, ~, S.dirpath_SubjectID ] = GUI.CONTROLLER.getSubjectID( handles );

if S.SaveMode && strcmp(S.OperationMode,'Acquisition')
    
    if ~exist(S.dirpath_SubjectID, 'dir')
        mkdir(S.dirpath_SubjectID);
    end
    
end

DataFile_noRun  = sprintf('%s_%s_%s', S.SubjectID, S.Environement, S.Task );
S.RunNumber     = GUI.MODEL.getRunNumber( S.dirpath_SubjectID, DataFile_noRun );
S.DataFileFPath = sprintf('%s%s_%s_%s_%s_run%0.2d', S.dirpath_SubjectID, S.TimeStampFile, S.SubjectID, S.Environement, S.Task, S.RunNumber );
S.DataFileName  = sprintf(  '%s_%s_%s_%s_run%0.2d',                      S.TimeStampFile, S.SubjectID, S.Environement, S.Task, S.RunNumber );


%% Quick warning

% Acquisition => save data
if strcmp(S.OperationMode,'Acquisition') && ~S.SaveMode
    warning('In acquisition mode, data should be saved')
end


%% Parallel port ?

if S.ParPort
    S.ParPortMessages = PARPORT.Prepare();
end


%% Eyelink ?

if S.EyelinkMode
    
    % 'Eyelink.m' exists ?
    assert( ~isempty(which('Eyelink.m')), 'no ''Eyelink.m'' detected in the path')
    
    % Save mode ?
    assert( SaveMode ,' \n ---> Save mode should be turned ON when using Eyelink <--- \n ')
    
    % Eyelink connected ?
    Eyelink.IsConnected();
    
    % Generate the Eyelink filename
    eyelink_max_finename = 8;                                                       % Eyelink filename must be 8 char or less...
    available_char        = ['a':'z' 'A':'Z' '0':'9'];                              % This is all characters available (N=62)
    name_num              = randi(length(available_char),[1 eyelink_max_finename]); % Pick 8 numbers, from 1 to N=62 (same char can be picked twice)
    name_str              = available_char(name_num);                               % Convert the 8 numbers into char
    
    % Save it
    S.EyelinkFile = name_str;
    
end


%% Security : NEVER overwrite a file
% If erasing a file is needed, we need to do it manually

if S.SaveMode && strcmp(S.OperationMode,'Acquisition')
    assert( ~exist([S.DataFileFPath '.mat'],'file'), ' \n ---> \n The file %s.mat already exists .  <--- \n \n', S.DataFileFPath );
end


%% Open PTB window & sound, if need
% comment/uncomment as needed

PTB_ENGINE.VIDEO.Parameters(); % <= here is all paramters
if strcmp(S.Task, 'MentalRotation')
    % Call this function at the beginning of your experiment script before
    % calling *any* Psychtoolbox Screen() command, if you intend to use
    % low-level OpenGL drawing commands in your script as provided by
    % Richard Murrays moglcore extension.
    InitializeMatlabOpenGL();
end
PTB_ENGINE.VIDEO.OpenWindow(); % this opens the windows and setup the drawings according the the paramters above

% PTB_ENGINE.AUDIO.         Initialize(); % !!! This must be done once before !!!
% PTB_ENGINE.AUDIO.PLAYBACK.Parameters(); % <= here is all paramters
% PTB_ENGINE.AUDIO.PLAYBACK.OpenDevice(); % this opens the playback device (speakers/headphones) and setup according the the paramters above
% PTB_ENGINE.AUDIO.RECORD  .Parameters(); % <= here is all paramters
% PTB_ENGINE.AUDIO.RECORD  .OpenDevice(); % this opens the record device (microphone) and setup according the the paramters above

PTB_ENGINE.KEYBOARD.Parameters(); % <= here is paramters non Task specific


%% Everything is read, start Task

EchoStart(S.Task)

if strcmp(S.Task, 'EyelinkCalibration')
    Eyelink.Calibration(S.PTB.Video.wPtr);
    S.TaskData.ER.Data = {};
else
    % TASK.TASK_1.Parameters <= here is all paramters
    TASK.(S.Task).Runtime() % execution of the task
end

EchoStop(S.Task)


%% Save the file on the fly, without any prcessing => just a security

save( fullfile(fileparts(pwd),'data','lastS.mat') , 'S' )


%% Stop PTB engine

% Video : comment/uncomment
sca;
Priority(0);

% Audio : comment/uncomment
% PsychPortAudio('Close');


%% Generate SPM names onset durations

[ names , onsets , durations, pmod, orth, tmod ] = TASK.(S.Task).SPMnod();


%% Save

if S.SaveMode && strcmp(S.OperationMode,'Acquisition')
    
    save( S.DataFileFPath        , 'S', 'names', 'onsets', 'durations', 'pmod', 'orth', 'tmod'); % complet file
    save([S.DataFileFPath '_SPM']     , 'names', 'onsets', 'durations', 'pmod', 'orth', 'tmod'); % light weight file with only the onsets for SPM
    
end


%% Send S and SPM n.o.d. to workspace

assignin('base', 'S'        , S        );
assignin('base', 'names'    , names    );
assignin('base', 'onsets'   , onsets   );
assignin('base', 'durations', durations);
assignin('base', 'pmod'     , pmod     );
assignin('base', 'orth'     , orth     );
assignin('base', 'tmod'     , tmod     );


%% MAIN : End recording of Eyelink

% Eyelink mode 'On' ?
if S.EyelinkMode
    
    % Stop recording and retrieve the file
    Eyelink.StopRecording( S.EyelinkFile )
    
end


%% Ready for another run

set(handles.text_LastFileNameAnnouncer, 'Visible', 'on')
set(handles.text_LastFileName         , 'Visible', 'on')
set(handles.text_LastFileName         , 'String' , S.DataFileName)

WaitSecs(0.100);
pause(0.100);
fprintf('\n')
fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n')
fprintf('    Ready for another run    \n')
fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n')


end % function
