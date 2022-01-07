function [ MovieMode ] = getMovieMode( handles )

switch get(get(handles.uipanel_Movie,'SelectedObject'),'Tag')
    case 'radiobutton_movie_off'
        MovieMode = 0;
    case 'radiobutton_movie_on'
        MovieMode = 1;
    otherwise
        warning('Error in MovieMode selection')
end

end % function
