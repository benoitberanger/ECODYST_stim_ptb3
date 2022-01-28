function p = Graphics( p )

p.FixationCross.Size     = 0.10;          %  Size_px = ScreenY_px * Size
p.FixationCross.Width    = 0.10;          % Width_px =    Size_px * Width
p.FixationCross.Color    = [000 000 000]; % [R G B a], from 0 to 255
p.FixationCross.Position = [0.50 0.50];   % Position_px = [ScreenX_px ScreenY_px] .* Position


end % function
