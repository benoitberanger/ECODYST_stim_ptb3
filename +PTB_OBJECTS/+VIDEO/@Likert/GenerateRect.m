function GenerateRect( self )

% line
self.line_rect = [0 0 self.line_width self.line_thickness];
self.line_rect = CenterRectOnPoint(self.line_rect, self.center(1), self.center(2));

% cursor
self.cursor_rect = [0 0 self.cursor_thickness self.cursor_height];
self.cursor_rect = CenterRectOnPoint(self.cursor_rect, self.center(1)*0.9, self.center(2));

end % function
