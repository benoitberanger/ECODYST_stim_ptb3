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
    cam_center(1)+self.camera_pos(1), cam_center(2)+self.camera_pos(2), cam_center(3)+self.camera_pos(3), ...
    cam_center(1)                   , cam_center(2)                   , cam_center(3)                   , ...
    0,1,0); % axis Y is the "up" axis

glTranslatef( cam_center(1),  cam_center(2),  cam_center(3));
glRotatef(theta,rotatev(1),rotatev(2),rotatev(3));
glTranslatef(-cam_center(1), -cam_center(2), -cam_center(3));

glPushMatrix();
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 0.5 0.5 0.5  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 1.0 1.0 1.0  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS, 30);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR,[ 1.0 1.0 1.0  1.0 ]);
% glutSolidSphere(1.1,100,100)
self.drawCubeTextured(tetris_axis); % cube size is 1.000
glPopMatrix();

glPushMatrix();
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 8.0 8.0 8.0  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 2.0 2.0 2.0  1.0 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS, 30);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR,[ 0.0 0.0 0.0  1.0 ]);
self.drawCubeWired(tetris_axis, 1.005)
% glutSolidSphere(1.1,100,100)
glPopMatrix();


Screen('EndOpenGL', self.wPtr);
end % function
