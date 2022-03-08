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
% in each Runtime(), here is only the non task specific recorders


%% Prepare the keylogger, including MRI triggers
% This will record all keys using KbQueue* functions, for passive key
% logging

KbName('UnifyKeyNames');

S.KL = KbLogger( ...
    [       struct2array(S.Keybinds.Common) struct2array(S.Keybinds.TaskSpecific)]   ,...
    KbName([struct2array(S.Keybinds.Common) struct2array(S.Keybinds.TaskSpecific)]) );

% Start recording events
S.KL.Start();


end % function
