function Keybindings()
global S

switch S.Environement
    
    case 'MRI' %-----------------------------------------------------------
        
        switch S.Task
            
            case 'MentalRotation'
                S.Keybinds.TaskSpecific.Same     = KbName('b'); % blue   in right hand
                S.Keybinds.TaskSpecific.Mirror   = KbName('y'); % yellow in left  hand
                
            case 'NBack'
                S.Keybinds.TaskSpecific.Catch    = KbName('b'); % blue   in right hand
                
            case 'SocialCognition'
                S.Keybinds.TaskSpecific.Right    = KbName('b'); % blue   in right hand
                S.Keybinds.TaskSpecific.Left     = KbName('y'); % yellow in left  hand
                
        end
        
    case 'Keyboard' %------------------------------------------------------
        
        switch S.Task
            
            case 'MentalRotation'
                S.Keybinds.TaskSpecific.Same     = KbName('RightArrow');
                S.Keybinds.TaskSpecific.Mirror   = KbName('LeftArrow');
                
            case 'NBack'
                S.Keybinds.TaskSpecific.Catch    = KbName('RightArrow');
                
            case 'SocialCognition'
                S.Keybinds.TaskSpecific.Right    = KbName('RightArrow');
                S.Keybinds.TaskSpecific.Left     = KbName('LeftArrow');
                
        end
        
end

end % function
