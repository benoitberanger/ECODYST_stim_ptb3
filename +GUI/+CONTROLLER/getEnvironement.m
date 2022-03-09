function [ Environement ] = getEnvironement( handles )

radiobutton = get(get(handles.uipanel_Environement,'SelectedObject'),'Tag');

Environement = strrep( radiobutton, 'radiobutton_Env_', '' );

end % function
