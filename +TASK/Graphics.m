function p = Graphics( p )


%% FixationCross (common)

p.FixationCross.Size     = 0.10;              %  Size_px = ScreenY_px * Size
p.FixationCross.Width    = 0.10;              % Width_px =    Size_px * Width
p.FixationCross.Color    = [127 127 127 255]; % [R G B a], from 0 to 255
p.FixationCross.Position = [0.50 0.50];       % Position_px = [ScreenX_px ScreenY_px] .* Position


%% MentalRotation

% LIGHT0
p.Tetris3D.LIGHT0.pos      = [0 +10 0];   % [X Y Z] OpenGL coordinates
p.Tetris3D.LIGHT0.is_pt    = 1;           % 0 == infinit distance (direction) // 1 == finit distance (point)
p.Tetris3D.LIGHT0.AMBIANT  = [0.1 0.1 0.1  1.0]; % [R G B a] OpenGL style
p.Tetris3D.LIGHT0.DIFFUSE  = [1.0 1.0 1.0  1.0]; % [R G B a] OpenGL style
p.Tetris3D.LIGHT0.SPECULAR = [1.0 1.0 1.0  1.0]; % [R G B a] OpenGL style

% LIGHT1
p.Tetris3D.LIGHT1.pos      = [0 -10 0];   % [X Y Z] OpenGL coordinates
p.Tetris3D.LIGHT1.is_pt    = 0;           % 0 == infinite distance (direction) // 1 == finite distance (point)
p.Tetris3D.LIGHT1.AMBIANT  = [0.0 0.0 0.0  1.0]; % [R G B a] OpenGL style
p.Tetris3D.LIGHT1.DIFFUSE  = [0.2 0.2 0.2  1.0]; % [R G B a] OpenGL style
p.Tetris3D.LIGHT1.SPECULAR = [0.0 0.0 0.0  1.0]; % [R G B a] OpenGL style

% Camera
p.Tetris3D.FieldOfView     = 30;          % degree
p.Tetris3D.Camera_pos      = [10 10 10];  % [X Y Z] OpenGL coordinates
p.Tetris3D.InitialRotVect  = [0 1 1];     % [X Y Z] OpenGL coordinates
p.Tetris3D.InitialRotAngle = 30;          % degree

% Texture on the cube
p.Tetris3D.nPixel_cubeface = 32; % powers of 2 are faster for redering

% Textured cube
p.Tetris3D.TexturedCube.AMBIENT   = [ 0.5 0.5 0.5  1.0 ]; % [R G B a] OpenGL style
p.Tetris3D.TexturedCube.DIFFUSE   = [ 1.0 1.0 1.0  1.0 ]; % [R G B a] OpenGL style
p.Tetris3D.TexturedCube.SHININESS = 30;                   % 0 .. 128
p.Tetris3D.TexturedCube.SPECULAR  = [ 1.0 1.0 1.0  1.0 ]; % [R G B a] OpenGL style

% Wired cube
p.Tetris3D.WiredCube.AMBIENT   = [ 0.0 0.0 0.0  1.0 ]; % [R G B a] OpenGL style
p.Tetris3D.WiredCube.DIFFUSE   = [ 0.0 0.0 0.0  1.0 ]; % [R G B a] OpenGL style
p.Tetris3D.WiredCube.SHININESS = 30;                   % 0 .. 128
p.Tetris3D.WiredCube.SPECULAR  = [ 0.0 0.0 0.0  1.0 ]; % [R G B a] OpenGL style
p.Tetris3D.WiredCube.LineWidth = 2.0;
p.Tetris3D.WiredCube.Size      = 1.01;


%% NBack

p.NBack.Text.SizeInstruction = 0.10;              % TextSize = round(ScreenY_px * Size)
p.NBack.Text.SizeStim        = 0.20;              % TextSize = round(ScreenY_px * Size)
p.NBack.Text.Color           = [127 127 127 255]; % [R G B a], from 0 to 255
p.NBack.Text.Center          = [0.5 0.5];         % Position_px = [ScreenX_px ScreenY_px] .* Position


%% SocialCognition

p.SocialCognition.Text.SizeInstruction = 0.08;              % TextSize = round(ScreenY_px * Size)
p.SocialCognition.Text.Color           = [255 255 255 255]; % [R G B a], from 0 to 255
p.SocialCognition.Text.Center          = [0.5 0.5];         % Position_px = [ScreenX_px ScreenY_px] .* Position


%% SimpleMotor

p.SimpleMotor.Text.SizeInstruction = 0.10;              % TextSize = round(ScreenY_px * Size)
p.SimpleMotor.Text.Color           = [127 127 127 255]; % [R G B a], from 0 to 255
p.SimpleMotor.Text.Center          = [0.5 0.5];         % Position_px = [ScreenX_px ScreenY_px] .* Position


%% Emotion

p.Emotion.Text.SizeInstruction = 0.10;              % TextSize = round(ScreenY_px * Size)
p.Emotion.Text.Color           = [127 127 127 255]; % [R G B a], from 0 to 255
p.Emotion.Text.Center          = [0.5 0.5];         % Position_px = [ScreenX_px ScreenY_px] .* Position

p.Emotion.Likert.line_width_ratio           = 0.80;              % line_width       = screen_width * ratio
p.Emotion.Likert.line_thickness_ratio       = 0.01;              % line_thickness   = screen_width * ratio
p.Emotion.Likert.line_color                 = [127 127 127 255]; % [R G B a], from 0 to 255

p.Emotion.Likert.tick_width_ratio           = 0.10;              % tick_width       = screen_width * ratio
p.Emotion.Likert.tick_thickness_ratio       = 0.01;              % tick_thickness   = screen_width * ratio
p.Emotion.Likert.tick_color                 = [127 127 127 255]; % [R G B a], from 0 to 255

% p.Emotion.Likert.cursor_width_ratio         = 0.15;              % cursor_width     = screen_width * ratio
% p.Emotion.Likert.cursor_thickness_ratio     = 0.01;              % cursor_thickness = screen_width * ratio
p.Emotion.Likert.cursor_color               = [125 111 133 255]; % [R G B a], from 0 to 255

p.Emotion.Likert.center                     = [0.50 0.75];       % center_px = [ScreenX_px ScreenY_px] .* center
p.Emotion.Likert.tick_label_bot_size_ratio  = 0.10;              % Size = ScreenY_px * ratio
p.Emotion.Likert.tick_label_top_size_ratio  = 0.05;              % Size = ScreenY_px * ratio


end % function
