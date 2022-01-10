function OpenDevice()
global S


%% Echo in command window
EchoStop(mfilename)


%% Open

% Playback device initialization
S.PTB.Audio.Playback.pahandle = PsychPortAudio('Open', [],... % open first device available
    1                                                    ,... % 1 means playback
    S.PTB.Audio.Playback.LowLatencyMode                  ,...
    S.PTB.Audio.Playback.SamplingFrequency               ,...
    S.PTB.Audio.Playback.Channels                        );

S.PTB.Audio.Playback.anticipation = 0.001; % in secondes


%% Warmup

PsychPortAudio('FillBuffer', S.PTB.Audio.Playback.pahandle, zeros(2,1e3));
PsychPortAudio('Start'     , S.PTB.Audio.Playback.pahandle, [], [], 1);


%% Echo in command window

EchoStop(mfilename)


end % function