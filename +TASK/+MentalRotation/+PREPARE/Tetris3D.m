function [ TETRIS3D ] = Tetris3D()
global S

TETRIS3D                      = PTB_OBJECTS.VIDEO.Tetris3D();
TETRIS3D.segment_length       = S.TaskParam.cube_segment;
TETRIS3D.camera_pos           = S.TaskParam.Tetris3D.Camera_pos;
TETRIS3D.init_rotation_vector = S.TaskParam.Tetris3D.InitialRotVect;
TETRIS3D.init_rotation_angle  = S.TaskParam.Tetris3D.InitialRotAngle;
TETRIS3D.nPixel_cubeface      = S.TaskParam.Tetris3D.nPixel_cubeface;
TETRIS3D.TexturedCube_AMBIENT   = S.TaskParam.Tetris3D.TexturedCube.AMBIENT;
TETRIS3D.TexturedCube_DIFFUSE   = S.TaskParam.Tetris3D.TexturedCube.DIFFUSE;
TETRIS3D.TexturedCube_SHININESS = S.TaskParam.Tetris3D.TexturedCube.SHININESS;
TETRIS3D.TexturedCube_SPECULAR  = S.TaskParam.Tetris3D.TexturedCube.SPECULAR;
TETRIS3D.WiredCube_AMBIENT      = S.TaskParam.Tetris3D.WiredCube.AMBIENT;
TETRIS3D.WiredCube_DIFFUSE      = S.TaskParam.Tetris3D.WiredCube.DIFFUSE;
TETRIS3D.WiredCube_SHININESS    = S.TaskParam.Tetris3D.WiredCube.SHININESS;
TETRIS3D.WiredCube_SPECULAR     = S.TaskParam.Tetris3D.WiredCube.SPECULAR;
TETRIS3D.WiredCube_LineWidth    = S.TaskParam.Tetris3D.WiredCube.LineWidth;
TETRIS3D.WiredCube_Size         = S.TaskParam.Tetris3D.WiredCube.Size;

TETRIS3D.LinkToWindowPtr(S.PTB.Video.wPtr);
TETRIS3D.genCubeTexture();
TETRIS3D.prepareNormal();

end % function
