function [ X ] = GetX ( self, mask )

if nargin < 2
    mask = self.mask;
end

switch mask
    case ''
        X = self.X;
    case 'NoMask'
        X = self.X;
    case 'ShuffleMask'
        X = self.X;
        X = reshape(X,[size(X,1)*size(X,2) size(X,3)]);
        X = X(Shuffle(1:size(X,1)),:);
        X = reshape(X,size(self.X));
    case 'DarkMask'
        X = self.X/10;
    otherwise
        error('invalied mask')
end

end % function
