function [ EyelinkMode ] = getEyelinkMode( handles )

switch get(get(handles.uipanel_EyelinkMode,'SelectedObject'),'Tag')
    case 'radiobutton_EyelinkOn'
        EyelinkMode = 1;
    case 'radiobutton_EyelinkOff'
        EyelinkMode = 0;
    otherwise
        error('Error in EyelinkMode selection')
end

end % function
