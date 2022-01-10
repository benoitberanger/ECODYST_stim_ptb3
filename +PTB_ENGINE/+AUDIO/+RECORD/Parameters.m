function Parameters()
global S

S.PTB.Audio.Record.LowLatencyMode    = 1;     % {0,1,2,3,4}
S.PTB.Audio.Record.SamplingFrequency = 44100; % Hz => !!! check the parameter of your device  !!!
S.PTB.Audio.Record.Channels          = 1;     % 1 = mono, 2 = stereo

end % function