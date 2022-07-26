classdef Likert < PTB_OBJECTS.VIDEO.Base
    %LIKERT Class to prepare and draw a Likert scale
    
    %% Properties
    
    properties
        
        % Parameters
        
        line_width              (1,1) double  % main line width, in pixel
        line_thickness          (1,1) double  % main line thickness, in pixel
        line_color              (1,4) uint8   % [R G B a] from 0 to 255
        
        tick_height             (1,1) double  % tick heigth, in pixel
        tick_thickness          (1,1) double  % tick thickness, in pixel
        tick_color              (1,4) uint8   % [R G B a] from 0 to 255
        
        cursor_color            (1,4) uint8   % [R G B a] from 0 to 255
        cursor_color_select     (1,4) uint8   % [R G B a] from 0 to 255
        cursor_color_valid      (1,4) uint8   % [R G B a] from 0 to 255
        
        center                  (1,2) double  % [ CenterX CenterY ] of the main line, in pixels
        
        tick_N                  (1,1) double  % number of ticks
        tick_label_bot_txt            cell    % usually : 1           2             3
        tick_label_top_txt            cell    % usually : not at all, indifferent , a lot
        tick_label_bot_size
        tick_label_top_size
        
        % Internal variables
        
        line_rect               (1,4) double  % coordinates of the main line for PTB, in pixels
        tick_rect                     double  % coordinates of all ticks for PTB, in pixels
        tick_pos                      double  % position of the tick X (center) in pixel
        tick_label_bot_pos      (1,1) double  % position of the bottom label Y in pixel
        tick_label_top_pos      (1,1) double  % position of the top    label Y in pixel
        
        tick_label_bot_offcet_x (1,1) double
        tick_label_bot_offcet_y (1,1) double
        tick_label_top_offcet_x (1,1) double
        tick_label_top_offcet_y (1,1) double
        
        cursor_rect             (1,4) double  % coordinates of the cursor for PTB, in pixels
        cursor_rect_middle      (1,4) double  % coordinates of the cursor for PTB, in pixels
        
        cursor_pos              (1,1) double  % cursor position in relative unit, from 1 to 7
        cursor_pos_middle       (1,1) double  % cursor position in relative unit, from 1 to 7
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
