function PrepareRecorders( EP )
global S


%% Prepare event record
% This object will record the real timings of stim events, for later
% comparaison with EP (EventPlaning) the expected onsets.

% Create
S.ER = EventRecorder( EP.Header , EP.EventCount );

% Prepare
S.ER.AddStartTime( 'StartTime' , 0 );


%% Behaviour recorder

switch S.Task
    
    case 'MentalRotation'
        S.BR = EventRecorder({'trial#' 'condition' 'tetris[4]' 'RT(s)' 'subj_resp' 'resp_ok'}, S.TaskParam.nTrials);
    case 'NBack'
        S.BR = EventRecorder({'trial#' 'block#' 'stim#' 'content' 'iscatch' 'RT(s)'}, S.TaskParam.nTrials);
end


%% Prepare the keylogger, including MRI triggers
% This will record all keys using KbQueue* functions, for passive key
% logging

KbName('UnifyKeyNames');

S.KL = KbLogger( ...
    struct2array(S.Keybinds)         ,...
    KbName(struct2array(S.Keybinds)) );

% Start recording events
S.KL.Start();


end % function
