function deleteTextures( self )
Screen('BeginOpenGL', self.wPtr);

% Delete all allocated OpenGL textures:
glDeleteTextures(length(self.tex_cubeface),self.tex_cubeface);

Screen('EndOpenGL', self.wPtr);
end % function
