function [ Task ] = getTask( hObject )

Task = strrep( get(hObject,'Tag'), 'pushbutton_', '' );

end % function
