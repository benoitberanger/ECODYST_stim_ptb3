function coords = getBarycenter( self, tetris_axis )
% tetris_axis = [+1 +3 -2 -1] means +X +Z -Y -X

% empty array that will contain the middle point of each segement
middles = NaN(length(tetris_axis),3);
dxyz    = NaN(length(tetris_axis),3);

nSegment = length(tetris_axis);

for iSegment = 1 : nSegment
    
    seg = [0 0 0];
    ax  =  abs(tetris_axis(iSegment));
    dir = sign(tetris_axis(iSegment));
    seg(ax) = dir*(self.segment_length(iSegment)-1);
    
    if iSegment == 1
        start_point = [0 0 0];
    else
        % start_point is simply the sum of each previous displacement
        start_point = sum(dxyz(1:(iSegment-1),:),1);
    end
    
    middles(iSegment,:) = start_point + seg/2;
    dxyz   (iSegment,:) = seg;
    
end

weights = self.segment_length; % the weigth is the length of each segment
coords = sum( middles.*weights' ) / sum(weights); % weigted sum

coords = PTB_OBJECTS.GEOMETRY.Point(coords);

end % function
