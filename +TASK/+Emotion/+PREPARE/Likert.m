function [ LIKERT ] = Likert()
global S

ScreenX_px = S.PTB.Video.X_total_px;
ScreenY_px = S.PTB.Video.Y_total_px;

LIKERT = PTB_OBJECTS.VIDEO.Likert();

LIKERT.line_width       = S.TaskParam.Emotion.Likert.line_width_ratio     * ScreenX_px;
LIKERT.line_thickness   = S.TaskParam.Emotion.Likert.line_thickness_ratio * ScreenX_px;
LIKERT.line_color       = S.TaskParam.Emotion.Likert.line_color;

LIKERT.tick_height      = S.TaskParam.Emotion.Likert.tick_width_ratio     * ScreenX_px;
LIKERT.tick_thickness   = S.TaskParam.Emotion.Likert.tick_thickness_ratio * ScreenX_px;
LIKERT.tick_color       = S.TaskParam.Emotion.Likert.tick_color;

LIKERT.cursor_height    = S.TaskParam.Emotion.Likert.cursor_width_ratio     * ScreenX_px;
LIKERT.cursor_thickness = S.TaskParam.Emotion.Likert.cursor_thickness_ratio * ScreenX_px;
LIKERT.cursor_color     = S.TaskParam.Emotion.Likert.cursor_color;

LIKERT.center           = S.TaskParam.Emotion.Likert.center.*[ScreenX_px ScreenY_px];

LIKERT.tick_label       = S.TaskParam.Emotion.Likert.tick_label;

LIKERT.LinkToWindowPtr(S.PTB.Video.wPtr);

LIKERT.GenerateRect();

end % function
