function PlayInMatlab( self )

self.AssertSignalReady();

player = audioplayer(self.signal,self.fs);
player.playblocking();

player.delete();
clear player

end
