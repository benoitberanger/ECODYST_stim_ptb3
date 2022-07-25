function Load( self )

[signal, self.fs] = psychwavread(self.filename);

if size(signal,2) == 1
    self.signal    = [signal';signal'];
elseif size(signal,2) == 2
    self.signal    = signal';
else
    error('??')
end
self.time        = (0:1:length(self.signal(1,:))-1)/self.fs;
self.duration    = length(self.signal)/self.fs;

end
