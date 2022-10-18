function Parameters()
global S

S.PTB.Audio.Record.LowLatencyMode    = 0;     % {0,1,2,3,4} % on Windows, use 0, because with 1 it starts, but records nothing
% S.PTB.Audio.Record.SamplingFrequency = 44100; % Hz => !!! check the parameter of your device  !!!
S.PTB.Audio.Record.SamplingFrequency = [];    % use default freq
S.PTB.Audio.Record.Channels          = 1;     % 1 = mono, 2 = stereo
S.PTB.Audio.Record.BufferSizeSec     = 120;   % allocated buffer size in seconds, MUST be larger then max(event_dur)

end % function
