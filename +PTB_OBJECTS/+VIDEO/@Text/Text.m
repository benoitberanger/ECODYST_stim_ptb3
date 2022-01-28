classdef Text < PTB_OBJECTS.VIDEO.Base
    %TEXT Class to prepare and draw text, such as instructions
    
    %% Properties
    
    properties
        
        % Parameters
        
        size          = zeros(0)   % font size
        color_Active  = zeros(0,4) % [R G B a] from 0 to 255
        color_Passive = zeros(0,4) % [R G B a] from 0 to 255
        center        = zeros(0,2) % [ CenterX CenterY ] of the text, in pixels
        
        content = '<<<DEFAULT_TEXT>>>' % this will be the text to display
        
        % Internal variables
        
        rect = zeros(0,4) % coordinates of the text rectangle for PTB, in pixels
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
    
end % classef
