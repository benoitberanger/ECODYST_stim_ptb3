classdef Text < PTB_OBJECTS.VIDEO.Base
    %TEXT Class to prepare and draw text, such as instructions
    
    %% Properties
    
    properties
        
        % Parameters
        
        size_Instruction (1,1) double % font size
        size_Stim        (1,1) double % font size
        color            (1,4) uint8  % [R G B a] from 0 to 255
        center           (1,2) double % [ CenterX CenterY ] of the text, in pixels
        
        content          (1,:) char = '<<<DEFAULT_TEXT>>>'    % this will be the text to display
        
        % Internal variables
        
        rect (1,4) double % coordinates of the text rectangle for PTB, in pixels
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
    
end % classef
