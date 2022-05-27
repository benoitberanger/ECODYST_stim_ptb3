function [ prevRect ] = GenerateRect( self )

prevRect = self.currRect;

self.currRect = CenterRectOnPoint( ScaleRect(self.baseRect, self.scale, self.scale) ,...
    self.center(1), ...
    self.center(2) );

end % function