function Draw( self, txt )

if nargin < 2
    txt = '';
end

self.DrawQuestion(txt);
self.DrawLine();
self.DrawTick();
self.DrawCursor();

end % function
