function Load( self )

% Load image in MATLAB
[self.X, self.map, self.alpha] = imread(self.filename);

% Generate base rectagle (original)
self.baseRect  = [0 0 size(self.X,2) size(self.X,1)];

% Initialize the center
[self.center(1), self.center(2)] = RectCenter(self.baseRect);

end % function
