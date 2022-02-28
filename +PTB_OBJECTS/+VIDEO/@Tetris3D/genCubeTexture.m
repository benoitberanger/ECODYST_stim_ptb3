function genCubeTexture( self )
global GL
Screen('BeginOpenGL', self.wPtr);


px = 32;

self.tex_cubeface = glGenTextures(6);

for i = 1 : 6
    
    % Enable i'th texture by binding it:
    glBindTexture(GL.TEXTURE_2D,self.tex_cubeface(i));
    
    img = max(-5,min(randn(px,px),+5)); % [-5 +5]
    img = 127 * img / 5 + 127;         % [0 255]
    img = repmat (img, [1 1 3]);       % standard [h, w, rgb]
    img = permute(img, [3 2 1]);       % opengl : [rgb, h, w]
    img = uint8(img);                  % convert to unsigned 8bit values
    
    % Assign image in matrix 'tx' to i'th texture:
    glTexImage2D(GL.TEXTURE_2D, 0, GL.RGB, px, px, 0, GL.RGB, GL.UNSIGNED_BYTE, img);
    
    % Setup texture wrapping behaviour:
    glTexParameterfv(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
    glTexParameterfv(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
    
    % Setup filtering for the textures:
    glTexParameterfv(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
    glTexParameterfv(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
    
    % Choose texture application function: It shall modulate the light
    % reflection properties of the the cubes face:
    glTexEnvfv(GL.TEXTURE_ENV, GL.TEXTURE_ENV_MODE, GL.MODULATE);
    
end


Screen('EndOpenGL', self.wPtr);
end % function
