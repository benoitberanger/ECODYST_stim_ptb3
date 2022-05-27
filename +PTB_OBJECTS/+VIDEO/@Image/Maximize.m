function Maximize( self )

ratio_x = self.baseRect(3) / self.screen_x;
ratio_y = self.baseRect(4) / self.screen_y;

ratio_max = max(ratio_x,ratio_y);
self.currRect = ScaleRect(self.baseRect,1/ratio_max,1/ratio_max);
self.currRect = CenterRectOnPoint(self.currRect, self.screen_x/2, self.screen_y/2);

end % function
