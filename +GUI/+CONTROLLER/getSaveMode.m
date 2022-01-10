function [ SaveMode ] = getSaveMode( handles )

radiobutton = get(get(handles.uipanel_SaveMode,'SelectedObject'),'Tag');

SaveMode_str = strrep( radiobutton, 'radiobutton_Save_', '' );

SaveMode = str2double(SaveMode_str);

end % function
