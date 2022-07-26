function DrawQuestion( self, txt )

Screen('TextSize', self.wPtr, self.tick_label_top_size);
DrawFormattedText(self.wPtr, txt, 'center', self.question_pos, self.tick_color);

end % function
