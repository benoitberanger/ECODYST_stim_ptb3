function GenerateRectCursor( self )

self.cursor_rect = self.tick_rect(:,self.cursor_pos_middle)';

% grow the initial rectangle step by step, for easier coordinate computation
self.cursor_rect(4) = self.cursor_rect(4) * 1.02;
self.cursor_rect(1) = self.cursor_rect(1) - self.tick_label_bot_offcet_x;
self.cursor_rect(3) = self.cursor_rect(3) + self.tick_label_bot_offcet_x;
self.cursor_rect(1) = self.cursor_rect(1) * 0.99;
self.cursor_rect(3) = self.cursor_rect(3) * 1.01;
self.cursor_rect(2) = self.cursor_rect(2) - (self.tick_label_bot_offcet_y - self.tick_height/2);
self.cursor_rect(2) = self.cursor_rect(2) * 0.95;

self.cursor_rect_middle = self.cursor_rect;

end % function
