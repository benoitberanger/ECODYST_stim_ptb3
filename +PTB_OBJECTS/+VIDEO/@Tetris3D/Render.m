function Render( self, tetris_axis, theta, rotatev )
global GL
Screen('BeginOpenGL', self.wPtr);

% Reset
glClear();

% Setup modelview matrix: This defines the position, orientation and
% looking direction of the virtual camera:
glMatrixMode(GL.MODELVIEW);
glLoadIdentity();

cam_center = barycenter(tetris_axis, self.segment_length); % local function, see below
% cam_center = [0 0 0];

gluLookAt(...
    cam_center(1)+self.camera_pos(1), cam_center(2)+self.camera_pos(2), cam_center(3)+self.camera_pos(3), ...
    cam_center(1)                   , cam_center(2)                   , cam_center(3)                   , ...
    0,1,0); % axis Y is the "up" axis

glTranslatef( cam_center(1),  cam_center(2),  cam_center(3));
glRotatef(theta,rotatev(1),rotatev(2),rotatev(3));
glTranslatef(-cam_center(1), -cam_center(2), -cam_center(3));

glPushMatrix();
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 0.1 0.1 0.1  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 0.5 0.5 0.5  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS, 10);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR,[ 0.0 0.0 0.0  0.0 ]);
% glutSolidSphere(1.1,100,100)
draw_cubes(tetris_axis, self.segment_length, 'solid', 0.999)  % local function, see below
glPopMatrix();

glPushMatrix();
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 0.0 0.0 0.0  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 2.0 2.0 2.0  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS, 10);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR,[ 0.0 0.0 0.0  1.0 ]);
draw_cubes(tetris_axis, self.segment_length, 'wired', 1.005)  % local function, see below
% glutSolidSphere(1.1,100,100)
glPopMatrix();

Screen('EndOpenGL', self.wPtr);
end % function

function draw_cubes(tetris_axis, segment_length, type, dim)

switch type
    case 'solid'
        fcn = @glutSolidCube;
    case 'wired'
        fcn = @glutWireCube;
end

nSegment = length(tetris_axis);

for iSegment = 1 : nSegment
    
    seg = [0 0 0];
    ax  =  abs(tetris_axis(iSegment));
    dir = sign(tetris_axis(iSegment));
    seg(ax) = dir;
    nDisplacement = segment_length(iSegment) - 1;
    
    if iSegment == 1
        fcn(dim)
        % nDisplacement = nDisplacement -1;
    end
    for n = 1 : nDisplacement
        glTranslatef(seg(1),seg(2),seg(3)) % move
        fcn(dim)                           % draw
    end
    
end

end % function

function coords = barycenter(tetris_axis, segment_length)

% empty array that will contain the middle point of each segement
middles = NaN(length(tetris_axis),3);
ends    = NaN(length(tetris_axis),3);

nSegment = length(tetris_axis);

for iSegment = 1 : nSegment
    
    seg = [0 0 0];
    ax  =  abs(tetris_axis(iSegment));
    dir = sign(tetris_axis(iSegment));
    seg(ax) = dir*segment_length(iSegment);
    
    if iSegment == 1
        start_point = [0 0 0];
    else
        % start_point is simply the sum of each previous displacement
        start_point = sum(ends(1:(iSegment-1),:));
    end
    
    middles(iSegment,:) = start_point + seg/2;
    ends   (iSegment,:) = seg;
    
end

weights = abs(tetris_axis); % the weigth is the length of each segment
coords = sum( middles.*weights' ) / sum(weights); % weigted sum

end
