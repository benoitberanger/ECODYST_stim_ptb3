function [ moviePtr ] = Create()
global S

S.MovieFilename = [S.DataFile '.mov'];

moviePtr   = Screen('CreateMovie', S.PTB.Video.wPtr, S.MovieFilename, [], [], S.PTB.Video.FPS);
S.moviePtr = moviePtr;

end % function
