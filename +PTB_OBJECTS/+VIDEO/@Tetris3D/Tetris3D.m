classdef Tetris3D < PTB_OBJECTS.VIDEO.Base
    %TETRIS3D Class to prepare and draw 3D Tetris, using OpenGL rendering 
    
    %% Properties
    
    properties
        
        % Parameters
        segment_length  (1,:) double {mustBeInteger,mustBePositive}
        camera_pos      (1,1) PTB_OBJECTS.GEOMETRY.Point
        
        % Internal variables
        tex_cubeface                 % vector containing pointer to OpenGL texture
        cube_vertex
        cube_face
        cube_normal
        
        img_L_cropped (:,:,4) uint8 % R G B a
        img_R_cropped (:,:,4) uint8 % R G B a
        
        img_L_rect (1,4) double
        img_R_rect (1,4) double
        
        texture_L
        texture_R
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
