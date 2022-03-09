function AddFrameBackBuffer(wPtr, moviePtr, nFrames)

if nargin < 3
    nFrames = [];
end

Screen('AddFrameToMovie',wPtr,[],'backBuffer',moviePtr,nFrames);

end % function
