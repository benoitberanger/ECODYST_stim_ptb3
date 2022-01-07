function [ ScreenID ] = getScreenID( handles )

AvalableDisplays = get(handles.listbox_Screens,'String');
SelectedDisplay  = get(handles.listbox_Screens,'Value' );
ScreenID         = str2double( AvalableDisplays(SelectedDisplay) );

end % function
