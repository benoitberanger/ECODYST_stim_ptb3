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
                
            case 'SimpleMotor'
                S.Keybinds.TaskSpecific.K1       = KbName('b');
                S.Keybinds.TaskSpecific.K2       = KbName('y');
                S.Keybinds.TaskSpecific.K3       = KbName('g');
                S.Keybinds.TaskSpecific.K4       = KbName('r');
                
            case 'Emotion'
                S.Keybinds.TaskSpecific.Left     = KbName('b');
                S.Keybinds.TaskSpecific.Validate = KbName('y');
                S.Keybinds.TaskSpecific.Right    = KbName('g');
                
            case 'Fluency'
                S.Keybinds.TaskSpecific.NONE     = KbName('b');
                
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
                
            case 'SimpleMotor'
                S.Keybinds.TaskSpecific.K1      = KbName('h');
                S.Keybinds.TaskSpecific.K2      = KbName('j');
                S.Keybinds.TaskSpecific.K3      = KbName('k');
                S.Keybinds.TaskSpecific.K4      = KbName('l');
                
            case 'Emotion'
                S.Keybinds.TaskSpecific.Left     = KbName('LeftArrow');
                S.Keybinds.TaskSpecific.Validate = KbName('DownArrow');
                S.Keybinds.TaskSpecific.Right    = KbName('RightArrow');
                
            case 'Fluency'
                S.Keybinds.TaskSpecific.NONE     = KbName('b');
                
        end
        
end

end % function
