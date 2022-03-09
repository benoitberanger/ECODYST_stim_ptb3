function AddFrameFrontBuffer(wPtr, moviePtr, nFrames)

if nargin < 3
    nFrames = [];
end

Screen('AddFrameToMovie',wPtr,[],'frontBuffer',moviePtr,nFrames);

end % function
