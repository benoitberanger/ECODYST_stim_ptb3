function [ Task ] = getTask( hObject )

switch get(hObject,'Tag')
    
    case 'pushbutton_Calibration'
        Task = 'Calibration';
        
    case 'pushbutton_Nutcracker'
        Task = 'Nutcracker';
        
        
    case 'pushbutton_EyelinkCalibration'
        Task = 'EyelinkCalibration';
        
    otherwise
        error('Error in Task selection')
end

end % function
