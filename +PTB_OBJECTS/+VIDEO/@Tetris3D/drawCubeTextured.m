function drawCubeTextured( self, tetris_axis )
% tetris_axis = [+1 +3 -2 -1] means +X +Z -Y -X
global GL

% Enable 2D texture mapping, so the faces of the cube will show some nice
% images:
glEnable(GL.TEXTURE_2D);
% don't gorget this line before drawing with textures

nSegment = length(tetris_axis);

for iSegment = 1 : nSegment
    
    seg = [0 0 0];
    ax  =  abs(tetris_axis(iSegment));
    dir = sign(tetris_axis(iSegment));
    seg(ax) = dir;
    nDisplacement = self.segment_length(iSegment) - 1;
    
    if iSegment == 1
        % glutSolidCube(dim)
        drawCube(GL, self.tex_cubeface, self.cube_vertex, self.cube_face, self.cube_normal)
    end
    for n = 1 : nDisplacement
        glTranslatef(seg(1),seg(2),seg(3)) % move
        % glutSolidCube(dim)
        drawCube(GL, self.tex_cubeface, self.cube_vertex, self.cube_face, self.cube_normal)
    end
    
end


end % function

function drawCube(GL, tex_cubeface, cube_vertex, cube_face, cube_normal)

for idx = 1 : 6
    
    % Bind (Select) texture 'tx' for drawing:
    glBindTexture(GL.TEXTURE_2D, tex_cubeface(idx));
    
    % Begin drawing of a new quad:
    glBegin(GL.QUADS);
    
    % Assign n as normal vector for this polygons surface normal:
    glNormal3f(cube_normal(1,idx), cube_normal(2,idx), cube_normal(3,idx));
    
    % Define vertex 1 by assigning a texture coordinate and a 3D position:
    glTexCoord2f(0, 0);
    glVertex3f(cube_vertex(1,cube_face(idx,1)), cube_vertex(2,cube_face(idx,1)), cube_vertex(3,cube_face(idx,1)));
    % Define vertex 2 by assigning a texture coordinate and a 3D position:
    glTexCoord2f(1, 0);
    glVertex3f(cube_vertex(1,cube_face(idx,2)), cube_vertex(2,cube_face(idx,2)), cube_vertex(3,cube_face(idx,2)));
    % Define vertex 3 by assigning a texture coordinate and a 3D position:
    glTexCoord2f(1, 1);
    glVertex3f(cube_vertex(1,cube_face(idx,3)), cube_vertex(2,cube_face(idx,3)), cube_vertex(3,cube_face(idx,3)));
    % Define vertex 4 by assigning a texture coordinate and a 3D position:
    glTexCoord2f(0, 1);
    glVertex3f(cube_vertex(1,cube_face(idx,4)), cube_vertex(2,cube_face(idx,4)), cube_vertex(3,cube_face(idx,4)));
    % Done with this polygon:
    glEnd;
    
end

end
