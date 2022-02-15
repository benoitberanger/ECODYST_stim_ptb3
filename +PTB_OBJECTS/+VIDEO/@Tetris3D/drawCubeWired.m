function drawCubeWired( self, tetris_axis, dim )

nSegment = length(tetris_axis);

for iSegment = 1 : nSegment
    
    seg = [0 0 0];
    ax  =  abs(tetris_axis(iSegment));
    dir = sign(tetris_axis(iSegment));
    seg(ax) = dir;
    nDisplacement = self.segment_length(iSegment) - 1;
    
    if iSegment == 1
        glutWireCube(dim);
        % nDisplacement = nDisplacement -1;
    end
    for n = 1 : nDisplacement
        glTranslatef(seg(1),seg(2),seg(3)) % move
        glutWireCube(dim);
    end
    
end


end % function
