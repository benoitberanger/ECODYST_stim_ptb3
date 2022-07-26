function GenerateRectCursor( self )

middle_tick_idx = round(self.tick_N/2);
self.cursor_rect = self.tick_rect(:,middle_tick_idx)';

% grow the initial rectangle step by step, for easier coordinate computation
self.cursor_rect(4) = self.cursor_rect(4) * 1.02;
self.cursor_rect(1) = self.cursor_rect(1) - self.tick_label_bot_offcet_x;
self.cursor_rect(3) = self.cursor_rect(3) + self.tick_label_bot_offcet_x;
self.cursor_rect(1) = self.cursor_rect(1) * 0.99;
self.cursor_rect(3) = self.cursor_rect(3) * 1.01;
self.cursor_rect(2) = self.cursor_rect(2) - (self.tick_label_bot_offcet_y - self.tick_height/2);
self.cursor_rect(2) = self.cursor_rect(2) * 0.98;

end % function
