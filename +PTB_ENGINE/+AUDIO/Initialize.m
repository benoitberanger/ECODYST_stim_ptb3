function Initialize()
%% Echo in command window
EchoStop(mfilename)


%% Init

% Perform basic initialization of the sound driver:
InitializePsychSound(1);

% Close the audio device:
PsychPortAudio('Close');


%% Echo in command window

EchoStop(mfilename)


end % function