function LinkToPAhandle( self, pahandle )

self.AssertSignalReady();

try
    PsychPortAudio('GetStatus', pahandle);
    self.pahandle = pahandle;
catch err
    rethrow(err)
end

end
