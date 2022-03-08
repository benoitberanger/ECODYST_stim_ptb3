function Keybindings()
global S

switch S.Task
    
    case 'MentalRotation'
        S.Keybinds.TaskSpecific.Same     = KbName('RightArrow');
        S.Keybinds.TaskSpecific.Mirror   = KbName('LeftArrow');
        
    case 'NBack'
        S.Keybinds.TaskSpecific.Catch    = KbName('RightArrow');
        
end

end % function
