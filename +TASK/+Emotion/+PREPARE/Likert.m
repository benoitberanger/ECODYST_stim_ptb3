function [ LIKERT ] = Likert()
global S

ScreenX_px = S.PTB.Video.X_total_px;
ScreenY_px = S.PTB.Video.Y_total_px;

LIKERT = PTB_OBJECTS.VIDEO.Likert();
LIKERT.LinkToWindowPtr(S.PTB.Video.wPtr);

LIKERT.line_width          = S.TaskParam.Emotion.Likert.line_width_ratio          * ScreenX_px;
LIKERT.line_thickness      = S.TaskParam.Emotion.Likert.line_thickness_ratio      * ScreenX_px;
LIKERT.line_color          = S.TaskParam.Emotion.Likert.line_color;

LIKERT.tick_height         = S.TaskParam.Emotion.Likert.tick_width_ratio          * ScreenX_px;
LIKERT.tick_thickness      = S.TaskParam.Emotion.Likert.tick_thickness_ratio      * ScreenX_px;
LIKERT.tick_color          = S.TaskParam.Emotion.Likert.tick_color;

LIKERT.cursor_color_select = S.TaskParam.Emotion.Likert.cursor_color_select; LIKERT.cursor_color = LIKERT.cursor_color_select;
LIKERT.cursor_color_valid  = S.TaskParam.Emotion.Likert.cursor_color_valid;

LIKERT.center              = S.TaskParam.Emotion.Likert.center.*[ScreenX_px ScreenY_px];
LIKERT.tick_label_bot_size = S.TaskParam.Emotion.Likert.tick_label_bot_size_ratio * ScreenY_px; LIKERT.tick_label_bot_size = round(LIKERT.tick_label_bot_size);
LIKERT.tick_label_top_size = S.TaskParam.Emotion.Likert.tick_label_top_size_ratio * ScreenY_px; LIKERT.tick_label_top_size = round(LIKERT.tick_label_top_size);

LIKERT.GenerateRectLine();
LIKERT.SetTicks(S.TaskParam.likert_N, S.TaskParam.likert_label_bot, S.TaskParam.likert_label_top);
LIKERT.GenerateRectCursor();

end % function
