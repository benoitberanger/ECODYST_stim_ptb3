function Normalize( self )

self.signal = self.signal / max( max( abs( self.signal ) , [], 2 ) );

end % function
