function [ EyelinkMode ] = getEyelinkMode( handles )

radiobutton = get(get(handles.uipanel_EyelinkMode,'SelectedObject'),'Tag');

EyelinkMode_str = strrep(radiobutton, 'radiobutton_Eyelink_', '');

EyelinkMode = str2double(EyelinkMode_str);


end % function
