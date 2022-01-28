function LinkToWindowPtr( self, wPtr )

try
    Screen('GetWindowInfo',wPtr); % assert window exists and it's pointer is correct
    self.wPtr = wPtr;
catch err
    rethrow(err)
end

end % function
