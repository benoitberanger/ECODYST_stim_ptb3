function Parameters()
global S

KbName('UnifyKeyNames'); % for cross-platform compatibility

S.Keybinds.TTL_t       = KbName('t');     % MRI trigger has to be the first defined key
S.Keybinds.emulTTL_s   = KbName('s');
S.Keybinds.Stop_Escape = KbName('ESCAPE');

end % function
