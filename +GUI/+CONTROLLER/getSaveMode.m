function [ SaveMode ] = getSaveMode( handles )

switch get(get(handles.uipanel_SaveMode,'SelectedObject'),'Tag')
    case 'radiobutton_SaveData'
        SaveMode = 1;
    case 'radiobutton_NoSave'
        SaveMode = 0;
    otherwise
        warning('Error in SaveMode selection')
end

end % function
