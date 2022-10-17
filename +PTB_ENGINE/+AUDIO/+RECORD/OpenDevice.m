function OpenDevice()
global S


%% Echo in command window
EchoStop(mfilename)


%% Open


% Playback device initialization
S.PTB.Audio.Record.pahandle = PsychPortAudio('Open', [],... % open first device available
    2                                                  ,... % 2 means record
    S.PTB.Audio.Record.LowLatencyMode                  ,...
    S.PTB.Audio.Record.SamplingFrequency               ,...
    S.PTB.Audio.Record.Channels                        );


s = PsychPortAudio('GetStatus', S.PTB.Audio.Record.pahandle);
S.PTB.Audio.Record.SamplingFrequency = s.SampleRate;

% Preallocate an internal audio recording  buffer with a capacity of 60 seconds:
PsychPortAudio('GetAudioData', S.PTB.Audio.Record.pahandle, S.PTB.Audio.Record.BufferSizeSec);

S.PTB.Audio.Record.anticipation = 0.001; % in secondes


%% Warmup

PsychPortAudio('Start'       , S.PTB.Audio.Record.pahandle, [], [], 1);
WaitSecs(0.1);
PsychPortAudio('Stop'        , S.PTB.Audio.Record.pahandle);
PsychPortAudio('GetAudioData', S.PTB.Audio.Record.pahandle);


%% Echo in command window

EchoStop(mfilename)


end % function
