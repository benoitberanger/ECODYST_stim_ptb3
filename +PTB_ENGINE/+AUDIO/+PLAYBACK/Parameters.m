function Parameters()
global S

S.PTB.Audio.Playback.LowLatencyMode    = 1;     % {0,1,2,3,4}
S.PTB.Audio.Playback.SamplingFrequency = 44100; % Hz => !!! check the parameter of your device  !!!
S.PTB.Audio.Playback.Channels          = 2;     % 1 = mono, 2 = stereo

end % function