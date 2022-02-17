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
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
