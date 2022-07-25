function Resample( self, newFS )

signal(1,:)  = resample( self.signal(1,:), newFS, self.fs);
signal(2,:)  = resample( self.signal(2,:), newFS, self.fs);
self.signal   = signal;
self.fs       = newFS;
self.time     = (0:1:length(self.signal(1,:))-1)/self.fs;
self.duration = length(self.signal)/self.fs;

end
