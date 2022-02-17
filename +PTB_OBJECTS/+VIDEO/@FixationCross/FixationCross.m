classdef FixationCross < PTB_OBJECTS.VIDEO.Base
    %FIXATIONCROSS Class to prepare and draw a fixation cross in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        dim    (1,1) double  % size of cross arms, in pixels
        width  (1,1) double  % width of each arms, in pixels
        color  (1,4) uint8   % [R G B a] from 0 to 255
        center (1,2) double  % [ CenterX CenterY ] of the cross, in pixels
        
        % Internal variables
        
        allCoords (4,2) double % coordinates of the cross for PTB, in pixels
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
