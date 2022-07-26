function GenerateRectLine( self )

% line
self.line_rect = [0 0 self.line_width self.line_thickness];
self.line_rect = CenterRectOnPoint(self.line_rect, self.center(1), self.center(2));

end % function
