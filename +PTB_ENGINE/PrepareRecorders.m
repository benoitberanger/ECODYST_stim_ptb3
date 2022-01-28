function PrepareRecorders( EP )
global S


%% Prepare event record
% This object will record the real timings of stim events, for later
% comparaison with EP (EventPlaning) the expected onsets.

% Create
ER = EventRecorder( EP.Header , EP.EventCount );

% Prepare
ER.AddStartTime( 'StartTime' , 0 );

S.ER = ER;


%% Behaviour recorder

RT_produce = SampleRecorder({'onset(s)' 'block#' 'trial#' 'side(LR=-1+1)' 'RT(s)'}, S.TaskParam.nBlock * S.TaskParam.nTrialPerBlock);
RT_rest    = RT_produce.CopyObject();
Stability  = SampleRecorder({'onset(s)' 'block#' 'trial#' 'side(LR=-1+1)'...
    'sample_start' 'sample_stop' 'score_accuracy' 'ratio_over_under' 'score_overshot' 'score_undershot' 'score_stability' },...
    S.TaskParam.nBlock * S.TaskParam.nTrialPerBlock);

S.RT_produce = RT_produce;
S.RT_rest    = RT_rest;
S.Stability  = Stability;


%% Prepare the keylogger, including MRI triggers
% This will record all keys using KbQueue* functions, for passive key
% logging

KbName('UnifyKeyNames');

KL = KbLogger( ...
    struct2array(S.Keybinds)         ,...
    KbName(struct2array(S.Keybinds)) );

% Start recording events
KL.Start();

S.KL = KL;


end % function
