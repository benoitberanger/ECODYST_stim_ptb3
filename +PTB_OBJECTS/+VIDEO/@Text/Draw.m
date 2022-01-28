function Draw( self, content, color )

self.content = content;

Screen('TextSize' , self.wPtr, self.size );

%[nx, ny, textbounds, wordbounds] = DrawFormattedText(win, tstring [, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft][, winRect])
DrawFormattedText(self.wPtr, self.content, 'center', 'center', self.(['color_' color]), [], [], [], [], [], self.rect);

end % function
