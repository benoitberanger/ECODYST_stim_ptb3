function GenerateCoords( self )

hRect = [0 0 self.dim   self.width ];
vRect = [0 0 self.width self.dim   ];

self.allCoords = [
    CenterRectOnPoint(hRect, self.center(1), self.center(2))
    CenterRectOnPoint(vRect, self.center(1), self.center(2))
    ]';

end % function
