function [ TEXT ] = Text()
global S

TEXT                  = PTB_OBJECTS.VIDEO.Text();
TEXT.size_Instruction = S.TaskParam.NBack.Text.SizeInstruction * S.PTB.Video.Y_total_px                     ; % FontSize
TEXT.size_Stim        = S.TaskParam.NBack.Text.SizeStim        * S.PTB.Video.Y_total_px                     ; % FontSize
TEXT.color            = S.TaskParam.NBack.Text.Color                                                        ; % [R G B a] (0..255)
TEXT.center           = S.TaskParam.NBack.Text.Center .* [ S.PTB.Video.X_total_px S.PTB.Video.Y_total_px ]  ; % [Xpos Ypos] (px)

TEXT.GenerateRect();
TEXT.LinkToWindowPtr(S.PTB.Video.wPtr);
TEXT.AssertReady();

end % function
