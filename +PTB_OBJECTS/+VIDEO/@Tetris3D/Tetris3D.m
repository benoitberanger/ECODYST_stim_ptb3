classdef Tetris3D < PTB_OBJECTS.VIDEO.Base
    %TETRIS3D Class to prepare and draw 3D Tetris, using OpenGL rendering 
    
    %% Properties
    
    properties
        
        % Parameters
        segment_length               % vector integer : 1, 2 , 3, 4 ...
        camera_pos      = zeros(0,3) % [X Y Z] position in OpenGL
        
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
