function [ texPtr ] = MakeTexture( self )

assert(~isempty(self.wPtr), 'use LinkToWindowPtr first')

texPtr = Screen( 'MakeTexture', self.wPtr, cat(3, self.GetX(), self.alpha) );

self.texPtr = texPtr;

end % function