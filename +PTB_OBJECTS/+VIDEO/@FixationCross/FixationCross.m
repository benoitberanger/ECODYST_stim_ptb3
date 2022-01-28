classdef FixationCross < PTB_OBJECTS.VIDEO.Base
    %FIXATIONCROSS Class to prepare and draw a fixation cross in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        dim    = zeros(0)   % size of cross arms, in pixels
        width  = zeros(0)   % width of each arms, in pixels
        color  = zeros(0,4) % [R G B a] from 0 to 255
        center = zeros(0,2) % [ CenterX CenterY ] of the cross, in pixels
        
        % Internal variables
        
        allCoords = zeros(4,2) % coordinates of the cross for PTB, in pixels
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
