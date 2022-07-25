function [ AUDIOFILE ] = AudioFile()
global S


%% Check dir

filedir = fullfile( fileparts(pwd), 'audiofiles', S.SubjectID);
assert(exist(filedir,'dir')>0, '%s does not exist', filedir)


%% List files

list_mp3 = dir(fullfile(filedir, '*mp3'));
list_wav = dir(fullfile(filedir, '*wav'));

list = [list_mp3;list_wav];


%% Create objects

fprintf('loading all audio files ...\n');
t0 = GetSecs();
for i = 1 : length(list)
    
    AUDIOFILE(i)          = PTB_OBJECTS.AUDIO.File();
    AUDIOFILE(i).filename = fullfile(list(i).folder, list(i).name);
    if strcmp(S.OperationMode, 'FastDebug')
        AUDIOFILE(i).signal      = randn(2,S.PTB.Audio.Playback.SamplingFrequency);
        AUDIOFILE(i).fs          = S.PTB.Audio.Playback.SamplingFrequency;
        AUDIOFILE(i).time        = (0:1:length(AUDIOFILE(i).signal(1,:))-1)/AUDIOFILE(i).fs;
        AUDIOFILE(i).duration    = length(AUDIOFILE(i).signal)/AUDIOFILE(i).fs;
    else
        AUDIOFILE(i).Load();
    end
    AUDIOFILE(i).Normalize();
    AUDIOFILE(i).LinkToPAhandle(S.PTB.Audio.Playback.pahandle);
    
end
fprintf('took %gs to load all audio files \n', GetSecs()-t0);


end % function