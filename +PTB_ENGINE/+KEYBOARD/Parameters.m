function Parameters()
global S
% Here is only the non task specific keybindings

KbName('UnifyKeyNames'); % for cross-platform compatibility

S.Keybinds.Common.TTL_t       = KbName('t');     % MRI trigger has to be the first defined key
S.Keybinds.Common.emulTTL_s   = KbName('s');
S.Keybinds.Common.Stop_Escape = KbName('ESCAPE');

end % function
