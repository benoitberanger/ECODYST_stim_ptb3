classdef Base < handle
    % BASE is a 'virtual' class : all subclasses contain this virtual class methods and attributes
    
    properties
        
        wPtr     (1,1) double % Pointer to the PTB screen window
        wRect    (1,4) double % Rectangle of the Window
        screen_x (1,1) double % Width  (in pixel)
        screen_y (1,1) double % Height (in pixel)
        center_x (1,1) double % Window X center (in pixel)
        center_y (1,1) double % Window Y center (in pixel)
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        % no constructor : this is a 'virtual' object
        % -----------------------------------------------------------------
        
    end
    
end % classdef
