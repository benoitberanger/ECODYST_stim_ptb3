classdef Likert < PTB_OBJECTS.VIDEO.Base
    %LIKERT Class to prepare and draw a Likert scale
    
    %% Properties
    
    properties
        
        % Parameters
        
        line_width       (1,1) double  % main line width, in pixel
        line_thickness   (1,1) double  % main line thickness, in pixel
        line_color       (1,4) uint8   % [R G B a] from 0 to 255
        
        tick_height      (1,1) double  % tick heigth, in pixel
        tick_thickness   (1,1) double  % tick thickness, in pixel
        tick_color       (1,4) uint8   % [R G B a] from 0 to 255
        
        cursor_height    (1,1) double  % cursor heigth, in pixel
        cursor_thickness (1,1) double  % cursor thickness, in pixel
        cursor_color     (1,4) uint8   % [R G B a] from 0 to 255
        
        center           (1,2) double  % [ CenterX CenterY ] of the main line, in pixels
        
        tick_label       (7,1) cell    % all labels 
        
        % Internal variables
        
        line_rect        (1,4) double  % coordinates of the main line for PTB, in pixels
        tick_rect        (4,7) double  % coordinates of all ticks for PTB, in pixels
        
        cursor_rect      (1,4) double  % coordinates of the cursor for PTB, in pixels
        
        cursor_pos       (1,1) double  % cursor position in relative unit, from 1 to 7
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
