function p = Graphics( p )

p.FixationCross.Size     = 0.10;              %  Size_px = ScreenY_px * Size
p.FixationCross.Width    = 0.10;              % Width_px =    Size_px * Width
p.FixationCross.Color    = [127 127 127 255]; % [R G B a], from 0 to 255
p.FixationCross.Position = [0.50 0.50];       % Position_px = [ScreenX_px ScreenY_px] .* Position

p.Tetris3D.FieldOfView   = 30;         % degree
p.Tetris3D.LIGHT0_pos    = [0 +10 0];  % [X Y Z] OpenGL coordinates
p.Tetris3D.LIGHT0_is_pt  = 1;          % 0 == infinit distance (direction) // 1 == finit distance (point)
p.Tetris3D.LIGHT1_pos    = [0 -10 0];  % [X Y Z] OpenGL coordinates
p.Tetris3D.LIGHT1_is_pt  = 0;          % 0 == infinit distance (direction) // 1 == finit distance (point)
p.Tetris3D.Camera_pos    = [10 10 10];  % [X Y Z] OpenGL coordinates
% IMPORTANT NOTE : material (the cube) color & lighting paramters are
% stored directly in @Tetris3D.Render() method, they are too many
% paramters...
p.Tetris3D.InitialRotAngle = 30;      % degree
p.Tetris3D.InitialRotVect  = [0 1 1]; % [X Y Z] OpenGL coordinates

end % function
