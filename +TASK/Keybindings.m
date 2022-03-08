function Keybindings()
global S

switch S.Task
    
    case 'MentalRotation'
        S.Keybinds.Same     = KbName('RightArrow');
        S.Keybinds.Mirror   = KbName('LeftArrow');
        
    case 'NBack'
        S.Keybinds.Catch    = KbName('RightArrow');
        
end

end % function
