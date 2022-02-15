function coords = getBarycenter( self, tetris_axis )

% empty array that will contain the middle point of each segement
middles = NaN(length(tetris_axis),3);
ends    = NaN(length(tetris_axis),3);

nSegment = length(tetris_axis);

for iSegment = 1 : nSegment
    
    seg = [0 0 0];
    ax  =  abs(tetris_axis(iSegment));
    dir = sign(tetris_axis(iSegment));
    seg(ax) = dir*self.segment_length(iSegment);
    
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

end % function
