function tetris_axis = applyMirror(~, tetris_axis, is_mirror)

if is_mirror
    
    mirror_tetris = tetris_axis; % copy
    x_idx = abs(mirror_tetris) == 1; % in OpenGL, 'left right' axis is X
    mirror_tetris(x_idx) = -mirror_tetris(x_idx);
    tetris_axis = mirror_tetris; % replace
    
end

end % end
