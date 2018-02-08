function h = density_image(obj)
% Plot the density as an image using the current axis.

v = axis;
yrange = v(4) - v(3);
xrange = v(2) - v(1);
res = 50;
r = v(1):(xrange/res):v(2);
r2 = v(3):(yrange/res):v(4);
x = ndgridmat(r,r2)';
p = logProb(obj, x);
if 1
  h = imagesc(r, r2, reshape(p, length(r), length(r2)));
  set(gca, 'YDir', 'normal');
else
  h = mesh(r, r2, reshape(exp(p), length(r), length(r2)));
  rotate3d on;
end
