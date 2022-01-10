function [ OperationMode ] = getOperationMode( handles )

radiobutton = get(get(handles.uipanel_OperationMode,'SelectedObject'),'Tag');

OperationMode = strrep(radiobutton, 'radiobutton_', '');

end % function
