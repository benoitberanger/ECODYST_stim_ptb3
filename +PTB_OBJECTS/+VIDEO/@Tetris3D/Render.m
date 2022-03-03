function Render( self, tetris_axis, angle, is_mirror )
% tetris_axis = [+1 +3 -2 -1] means +X +Z -Y -X
global GL
Screen('BeginOpenGL', self.wPtr);


% Reset
glClear();

% Setup modelview matrix: This defines the position, orientation and
% looking direction of the virtual camera:
glMatrixMode(GL.MODELVIEW);
glLoadIdentity();

% mirror is on X axis, which is Left-Right 
tetris_axis = self.applyMirror(tetris_axis,is_mirror);

cam_center = self.getBarycenter(tetris_axis);
% cam_center = [0 0 0];

% continue mirrorize
camera_pos = PTB_OBJECTS.GEOMETRY.Point(self.camera_pos.xyz);
init_rotation_angle = self.init_rotation_angle;
switch is_mirror
    case 0
        % pass
    case 1
        camera_pos.x        = -camera_pos.x;
        init_rotation_angle = -init_rotation_angle;
    otherwise
        error('???')
end

gluLookAt(...
    cam_center.x+camera_pos.x, cam_center.y+camera_pos.y, cam_center.z+camera_pos.z, ...
    cam_center.x             , cam_center.y             , cam_center.z             , ...
    0,1,0); % axis Y is the "up" axis

glTranslatef( cam_center.x,  cam_center.y,  cam_center.z);
glRotatef(init_rotation_angle + angle,...
    self.init_rotation_vector.x,...
    self.init_rotation_vector.y,...
    self.init_rotation_vector.z ...
    );
glTranslatef(-cam_center.x, -cam_center.y, -cam_center.z);

glPushMatrix();
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 0.5 0.5 0.5  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 1.0 1.0 1.0  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS, 30);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR,[ 1.0 1.0 1.0  1.0 ]);
% glutSolidSphere(1.1,100,100)
self.drawCubeTextured(tetris_axis); % cube size is 1.000
glPopMatrix();

glPushMatrix();
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 0.0 0.0 0.0  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 0.0 0.0 0.0  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS, 30);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR,[ 0.0 0.0 0.0  1.0 ]);
% Set thickness of reference lines:
glLineWidth(2.0);
self.drawCubeWired(tetris_axis, 1.01)
% glutSolidSphere(1.1,100,100)
glPopMatrix();


Screen('EndOpenGL', self.wPtr);
end % function
