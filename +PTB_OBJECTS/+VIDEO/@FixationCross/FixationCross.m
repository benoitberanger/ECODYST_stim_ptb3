classdef FixationCross < PTB_OBJECTS.VIDEO.Base
    %FIXATIONCROSS Class to prepare and draw a fixation cross in PTB
    
    %% Properties
    
    properties (Dependent)
        
        
        
    end % properties
    
    properties
        
        % Parameters
        
        dim_ratio    (1,1) double % ratio from screen_y
        dim          (1,1) double % size of cross arms, in pixels

        width_ratio  (1,1) double % ratio from dim
        width        (1,1) double % width of each arms, in pixels
        
        center_ratio (1,2) double % ratio from [screen_x screen_y]
        center       (1,2) double % [ CenterX CenterY ] of the cross, in pixels
        
        color        (1,4) uint8  % [R G B a] from 0 to 255
        
        
        % Internal variables
        
        allCoords (4,2) double % coordinates of the cross for PTB, in pixels
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
        function set.dim_ratio(self, ratio)
            self.dim_ratio    = ratio;
            self.dim          = self.screen_y * ratio;
        end
        
        function set.width_ratio(self, ratio)
            self.width_ratio  = ratio;
            self.width        = self.dim * ratio;
        end
        
        function set.center_ratio(self, ratio)
            self.center_ratio = ratio;
            self.center       = [self.screen_x self.screen_y] .* ratio;
        end
        
    end % methods
    
    
end % class
