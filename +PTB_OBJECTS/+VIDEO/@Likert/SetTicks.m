function SetTicks( self, N, label_bot, label_top )

self.tick_N             = N;
self.tick_label_bot_txt = label_bot;
self.tick_label_top_txt = label_top;
self.cursor_pos_middle  = round(N/2);
self.cursor_pos         = self.cursor_pos_middle;

% tick
tick_rect = [0 0 self.tick_thickness self.tick_height];
tick_pos  = linspace(self.line_rect(1), self.line_rect(3), N);
self.tick_pos = tick_pos;
for i = 1 : N
    self.tick_rect(:,i) = CenterRectOnPoint(tick_rect, tick_pos(i), self.center(2))';
end

% compute label text rect (for positioning)
tick_label_bot_rect = GetTextBounds( self, self.tick_label_bot_txt, self.tick_label_bot_size );
tick_label_top_rect = GetTextBounds( self, self.tick_label_top_txt, self.tick_label_top_size );

self.tick_label_bot_offcet_x = (tick_label_bot_rect(3) - tick_label_bot_rect(1))/2;
self.tick_label_top_offcet_x = (tick_label_top_rect(3) - tick_label_top_rect(1))/2;

self.tick_label_bot_offcet_y = (tick_label_bot_rect(4) - tick_label_bot_rect(2)) + ...
    self.tick_height/2 * 1.1;
self.tick_label_top_offcet_y = (tick_label_top_rect(4) - tick_label_top_rect(2)) + ...
    self.tick_label_bot_offcet_y * 1.2;

end % function

function bounds = GetTextBounds( self, txt_cellstr, sz )

txt_char = char(txt_cellstr(:)');
textLength = size(txt_char,2);

woff = Screen('OpenOffscreenWindow',self.wPtr,[],[0 0 2*sz*textLength 2*sz]);
Screen(woff,'TextFont',Screen('TextFont', self.wPtr));
Screen(woff,'TextSize',sz);
yPositionIsBaseline = 1;
bounds=TextBounds(woff,txt_char,yPositionIsBaseline);
Screen('Close',woff);

end % function

