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
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT  , self.TexturedCube_AMBIENT  );
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE  , self.TexturedCube_DIFFUSE  );
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS, self.TexturedCube_SHININESS);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR , self.TexturedCube_SPECULAR );
% glutSolidSphere(1.1,100,100)
self.drawCubeTextured(tetris_axis); % cube size is 1.000
glPopMatrix();

glPushMatrix();
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT  , self.WiredCube_AMBIENT  );
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE  , self.WiredCube_DIFFUSE  );
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS, self.WiredCube_SHININESS);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR , self.WiredCube_SPECULAR );
% Set thickness of reference lines:
glLineWidth(self.WiredCube_LineWidth);
self.drawCubeWired(tetris_axis, self.WiredCube_Size)
% glutSolidSphere(1.1,100,100)
glPopMatrix();


Screen('EndOpenGL', self.wPtr);
end % function
