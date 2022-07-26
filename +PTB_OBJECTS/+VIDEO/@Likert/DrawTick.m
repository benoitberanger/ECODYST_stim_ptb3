function DrawTick( self )

% tick rects
Screen('FillRect', self.wPtr, self.tick_color, self.tick_rect)

% bottom labels
Screen('TextSize', self.wPtr, self.tick_label_bot_size);
for i = 1 : self.tick_N
    Screen('DrawText', self.wPtr, self.tick_label_bot_txt{i}, ...
        self.tick_pos(i)        - self.tick_label_bot_offcet_x, ...
        self.center(2) - self.tick_label_bot_offcet_y, ...
        self.tick_color);
end

% top labels
Screen('TextSize', self.wPtr, self.tick_label_top_size);
for i = 1 : self.tick_N
    Screen('DrawText', self.wPtr, self.tick_label_top_txt{i}, ...
        self.tick_pos(i)        - self.tick_label_top_offcet_x, ...
        self.center(2) - self.tick_label_top_offcet_y, ...
        self.tick_color);
end

end % function
