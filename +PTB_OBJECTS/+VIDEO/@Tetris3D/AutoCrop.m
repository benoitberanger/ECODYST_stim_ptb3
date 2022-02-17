function o = AutoCrop( ~, i )

% binarize
mask = sum(i>0,3) > 0;

% horizontal crop limit
vsum = sum(mask,1);
lr_limits = find(diff(vsum>0));
left_lim  = lr_limits(1);
right_lim = lr_limits(end)+1;

% horizontal crop limit
hsum      = sum(mask,2);
ud_limits = find(diff(hsum>0));
up_lim    = ud_limits(1);
down_lim  = ud_limits(end)+1;

% do the crop
o = cat(3, i(up_lim:down_lim, left_lim:right_lim, :), 255*mask(up_lim:down_lim, left_lim:right_lim, :));

end % function
