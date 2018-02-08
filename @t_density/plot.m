function plot(obj, color)

if nargin < 2
  color = 'g';
end

if rows(obj.mean) > 1
  h = plot(obj.mean(1, :), obj.mean(2, :), ['x' color]);
  set(h, 'Tag', 't_density');
  h = draw_ellipse(obj.mean(1:2), obj.cov(1:2, 1:2)/(obj.n-4), color);
  set(h, 'Tag', 't_density');
else
  v = axis;
  res = 100;
  yrange = v(4) - v(3);
  xrange = v(2) - v(1);
  r = v(1):(xrange/res):v(2);
  p = exp(logProb(obj, r));
  h = plot(r, p*yrange + v(3), color);
  set(h, 'Tag', 'normal_density');
end
