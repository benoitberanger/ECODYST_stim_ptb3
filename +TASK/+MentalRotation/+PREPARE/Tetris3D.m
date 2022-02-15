function [ TETRIS3D ] = Tetris3D()
global S

TETRIS3D                = PTB_OBJECTS.VIDEO.Tetris3D();
TETRIS3D.segment_length = S.TaskParam.cube_segment;
TETRIS3D.camera_pos     = S.TaskParam.Tetris3D.Camera_pos;

TETRIS3D.LinkToWindowPtr(S.PTB.Video.wPtr);
TETRIS3D.genCubeTexture();
TETRIS3D.prepareNormal();

TETRIS3D.AssertReady();

end % function
