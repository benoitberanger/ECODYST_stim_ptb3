function [ TEXT ] = Text()
global S

TEXT                  = PTB_OBJECTS.VIDEO.Text();
TEXT.size_Instruction = round(S.TaskParam.SimpleMotor.Text.SizeInstruction * S.PTB.Video.Y_total_px)              ; % FontSize
TEXT.color            = S.TaskParam.SimpleMotor.Text.Color                                                        ; % [R G B a] (0..255)
TEXT.center           = S.TaskParam.SimpleMotor.Text.Center .* [ S.PTB.Video.X_total_px S.PTB.Video.Y_total_px ]  ; % [Xpos Ypos] (px)

TEXT.GenerateRect();
TEXT.LinkToWindowPtr(S.PTB.Video.wPtr);
TEXT.AssertReady();

end % function
