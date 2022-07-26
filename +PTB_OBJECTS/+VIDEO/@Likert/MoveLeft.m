function MoveLeft( self )

if self.cursor_pos == 1
    return
end

self.cursor_rect = OffsetRect( self.cursor_rect, -(self.tick_pos(2)-self.tick_pos(1)), 0 );
self.cursor_pos = self.cursor_pos - 1;

end % function
