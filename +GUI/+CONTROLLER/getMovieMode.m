function [ MovieMode ] = getMovieMode( handles )
global S

radiobutton = get(get(handles.uipanel_Movie,'SelectedObject'),'Tag');

MovieMode_str = strrep(radiobutton, 'radiobutton_movie_', '');

MovieMode = str2double(MovieMode_str);

if MovieMode && ~(strcmp(S.OperationMode,'Acquisition') && S.SaveMode)
    MovieMode = 0;
    warning('Movie can only be savec with SaveMode=1 & OperationMode=''Acquisition''')
end

end % function
