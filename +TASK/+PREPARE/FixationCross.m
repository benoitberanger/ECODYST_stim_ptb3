function [ FIXATIONCROSS ] = FixationCross()
global S

FIXATIONCROSS = PTB_OBJECTS.VIDEO.FixationCross();
FIXATIONCROSS.LinkToWindowPtr(S.PTB.Video.wPtr);

FIXATIONCROSS.dim_ratio    = S.TaskParam.FixationCross.dim_ratio;     
FIXATIONCROSS.width_ratio  = S.TaskParam.FixationCross.width_ratio;   
FIXATIONCROSS.center_ratio = S.TaskParam.FixationCross.center_ratio;

FIXATIONCROSS.color        = S.TaskParam.FixationCross.Color;                                               ; % [R G B a] (0..255)

FIXATIONCROSS.GenerateCoords();
FIXATIONCROSS.AssertReady();

end % function
