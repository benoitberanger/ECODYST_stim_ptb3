function Capture( self, side )

img = Screen('GetImage', self.wPtr , [], 'backBuffer' );


cropped = self.AutoCrop(img);
rect = [0 0 size(cropped,2) size(cropped,1)];
texture = Screen('MakeTexture', self.wPtr, cropped);

self.(['img_'     side '_cropped']) = cropped;
self.(['img_'     side '_rect'   ]) = rect;
self.(['texture_' side           ]) = texture;


end % function

