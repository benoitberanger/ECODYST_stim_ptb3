function pushbutton_EyelinkCalibration(hObject, ~)
handles = guidata(hObject);

% Screen mode selection
AvalableDisplays = get(handles.listbox_Screens,'String');
SelectedDisplay = get(handles.listbox_Screens,'Value');
wPtr = str2double( AvalableDisplays(SelectedDisplay) );

Eyelink.OpenCalibration(wPtr);

end % function
