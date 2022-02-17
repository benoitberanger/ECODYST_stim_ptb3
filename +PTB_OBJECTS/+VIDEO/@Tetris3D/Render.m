function Render( self, tetris_axis, theta, rotatev )
global GL
Screen('BeginOpenGL', self.wPtr);


% Reset
glClear();

% Setup modelview matrix: This defines the position, orientation and
% looking direction of the virtual camera:
glMatrixMode(GL.MODELVIEW);
glLoadIdentity();

cam_center = self.getBarycenter(tetris_axis);
% cam_center = [0 0 0];

gluLookAt(...
    cam_center.x+self.camera_pos.x, cam_center.y+self.camera_pos.y, cam_center.z+self.camera_pos.z, ...
    cam_center.x                  , cam_center.y                  , cam_center.z                , ...
    0,1,0); % axis Y is the "up" axis

glTranslatef( cam_center.x,  cam_center.y,  cam_center.z);
glRotatef(theta,rotatev(1),rotatev(2),rotatev(3));
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
glLineWidth(4.0);
self.drawCubeWired(tetris_axis, 1.01)
% glutSolidSphere(1.1,100,100)
glPopMatrix();


Screen('EndOpenGL', self.wPtr);
end % function
