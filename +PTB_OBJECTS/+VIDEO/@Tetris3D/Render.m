function Render( self, tetris_axis )
global GL
Screen('BeginOpenGL', self.wPtr);

% Reset
glClear();
glMatrixMode(GL.MODELVIEW);
glLoadIdentity();

% Setup modelview matrix: This defines the position, orientation and
% looking direction of the virtual camera:
gluLookAt(...
    self.camera_pos(1), self.camera_pos(2), self.camera_pos(3),...
    0,0,0,...
    0,1,0);

glPushMatrix();
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 0.2 0.2 0.2 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 0.5 0.5 0.5 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS, 30);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR,[ 0.5 0.5 0.5 1 ]);
draw_cubes(tetris_axis, self.segment_length, 'solid', 0.999)
glPopMatrix();

glPushMatrix();
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 0.0 0.0 0.0 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 0.0 0.0 0.0 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR,[ 0.0 0.0 0.0 1 ]);
draw_cubes(tetris_axis, self.segment_length, 'wired', 1.005)
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
    ax  = abs(tetris_axis(iSegment));
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
