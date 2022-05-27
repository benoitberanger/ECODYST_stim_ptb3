function [ IMAGE ] = Image()
global S

% shortcut
block = S.TaskParam.block;

N = S.TaskParam.nTrials;

IMAGE = PTB_OBJECTS.VIDEO.Image().empty(N,0); % create array of objects
trial = 0;
for blk = 1 : length(block)
    for i = 1 : length(block(blk).img)
        trial = trial + 1;
        IMAGE(trial,1).filename = fullfile(S.TaskParam.imgDir, block(blk).img{i});
        IMAGE(trial,1).mask = 'NoMask';
        IMAGE(trial,1).LinkToWindowPtr(S.PTB.Video.wPtr);
        IMAGE(trial,1).GetScreenSize();
    end
end

end % function
