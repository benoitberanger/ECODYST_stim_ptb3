function Draw( self, content, type )

self.content = content;

Screen('TextSize' , self.wPtr, self.(sprintf('size_%s', type)) );

DrawFormattedText(self.wPtr, self.content, 'center', 'center', self.color, [], [], [], [], [], self.rect);

end % function
