classdef Image < PTB_OBJECTS.VIDEO.Base
    %IMAGE Class to load, prepare and draw image in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        filename  (1,:) char        % path of the image
        scale     (1,1) double = 1  % scaling factor of the image => 1 means original image
        center    (1,2) double      % [X-center-PTB, Y-center-PTB] in pixels, PTB coordinates
        mask      (1,:) char   = '' % mask of the images : str = 'NoMask', 'ShuffleMask', 'DarkMask'
        
        
        % Internal variables
        
        screen_x  (1,1) double % number of horizontal pixels of the screen
        screen_y  (1,1) double % number of vertical   pixels of the screen
        
        X         % image matrix
        map       % color map
        alpha     % transparency
        
        baseRect  (1,4) double % [x1 y1 x2 y2] pixels, PTB coordinates, original rectangle
        currRect  (1,4) double % [x1 y1 x2 y2] pixels, PTB coordinates, current  rectangle
        
        texPtr    (1,1) % pointer to the texure in PTB
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
