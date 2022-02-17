function Parameters()
global S

S.PTB.Video                = struct;
S.PTB.Video.ScreenBGColor  = [000 000 000]; % [R G B] ( from 0 to 255 )
S.PTB.Video.AntiAliazing   = 4;             % [], 0, 1, 2, ...
S.PTB.Video.Text.Font      = 'Arial';
S.PTB.Video.Text.Color     = [255 255 255]; % [R G B] ( from 0 to 255 )
S.PTB.Video.Text.SizeRatio = 0.10;          % Size = Y_total_px * SizeRatio
S.PTB.Video.GStreamer      = S.MovieMode;   % 0 or 1 when using video playback/recording

end % function
