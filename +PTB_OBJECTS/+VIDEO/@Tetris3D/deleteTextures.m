function deleteTextures( self )

% Delete all allocated OpenGL textures:
glDeleteTextures(length(self.tex_cubeface),self.tex_cubeface);

end % function
