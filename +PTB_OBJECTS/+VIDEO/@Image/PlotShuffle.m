function PlotShuffle( self )

f = figure('Name',self.filename,'NumberTitle','off');
ax = axes(f);
image(ax, self.GetX('ShuffleMask'))
% colormap(ax, gray(256))
set(ax, 'XAxisLocation', 'top')
axis(ax, 'equal')

end % function
