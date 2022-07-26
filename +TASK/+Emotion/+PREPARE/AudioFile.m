function [ AUDIOFILE ] = AudioFile()
global S


%% Check dir

filedir_common  = fullfile( fileparts(pwd), 'audiofiles');
filedir_subject = fullfile( filedir_common, S.SubjectID);
assert(exist(filedir_subject,'dir')>0, '%s does not exist', filedir_subject)


%% List files

list = {
    fullfile(filedir_common , 'baseline_instruction.mp3')
    fullfile(filedir_common , 'script_instruction.mp3')
    fullfile(filedir_common , 'recovery_instruction.mp3')
    fullfile(filedir_subject, 'Script_Relax1.mp3')
    fullfile(filedir_subject, 'Script_Relax2.mp3')
    fullfile(filedir_subject, 'Script_Stress1.mp3')
    fullfile(filedir_subject, 'Script_Stress2.mp3')
    };


%% Create objects

fprintf('loading all audio files ...\n');
t0 = GetSecs();
for i = 1 : length(list)
    
    AUDIOFILE(i)          = PTB_OBJECTS.AUDIO.File();
    AUDIOFILE(i).filename = list{i};
    if strcmp(S.OperationMode, 'FastDebug')
        AUDIOFILE(i).signal      = randn(2,S.PTB.Audio.Playback.SamplingFrequency)/50;
        AUDIOFILE(i).fs          = S.PTB.Audio.Playback.SamplingFrequency;
        AUDIOFILE(i).time        = (0:1:length(AUDIOFILE(i).signal(1,:))-1)/AUDIOFILE(i).fs;
        AUDIOFILE(i).duration    = length(AUDIOFILE(i).signal)/AUDIOFILE(i).fs;
    else
        AUDIOFILE(i).Load();
        AUDIOFILE(i).Normalize();
    end
    AUDIOFILE(i).LinkToPAhandle(S.PTB.Audio.Playback.pahandle);
    
end
fprintf('took %gs to load all audio files \n', GetSecs()-t0);


end % function