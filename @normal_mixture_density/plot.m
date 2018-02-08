function plot(obj, color)

if nargin < 2
  color = 'g';
end

if rows(obj.means) > 1
  % plot each component separately
  h = plot(obj.means(1, :), obj.means(2, :), ['x' color]);
  set(h, 'Tag', 'normal_mixture_density');
  h = draw_ellipse(obj.means(1:2, :), obj.cov, color);
  set(h, 'Tag', 'normal_mixture_density');
else
  % plot the whole probability surface
  v = axis;
  yrange = v(4) - v(3);
  xrange = v(2) - v(1);
  res = 50;
  r = v(1):(xrange/res):v(2);
  p = exp(logProb(obj, r));
  h = plot(r, p, color);
  set(h, 'Tag', 'normal_mixture_density');
end
