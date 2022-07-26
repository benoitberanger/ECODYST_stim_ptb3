function GenerateRect( self )

self.line_rect = [0 0 self.line_width self.line_thickness];
self.line_rect = CenterRectOnPoint(self.line_rect, self.center(1), self.center(2));

tick_rect = [0 0 self.tick_thickness self.tick_height];
tick_pos  = linspace(self.line_rect(1), self.line_rect(3), 7);
for i = 1 : 7
    self.tick_rect(:,i) = CenterRectOnPoint(tick_rect, tick_pos(i), self.center(2))';
end

self.cursor_rect = [0 0 self.cursor_thickness self.cursor_height];
self.cursor_rect = CenterRectOnPoint(self.cursor_rect, self.center(1)*0.9, self.center(2));

end % function
