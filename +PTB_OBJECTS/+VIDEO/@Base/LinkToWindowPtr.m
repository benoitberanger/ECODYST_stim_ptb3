function LinkToWindowPtr( self, wPtr )

try
    Screen('GetWindowInfo',wPtr); % assert window exists and it's pointer is correct
    self.wPtr = wPtr;
    
    % fetch useful info, later used on 'Dependent' proprerties
    self.wRect = Screen('Rect', wPtr);
    [ self.center_x , self.center_y ] = RectCenter( self.wRect );
    self.screen_x = self.wRect(3);
    self.screen_y = self.wRect(4);
    
catch err
    rethrow(err)
end

end % function
