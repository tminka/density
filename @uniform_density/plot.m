function h = plot(obj, color)

if nargin < 2
  color = 'g';
end

if rows(obj.a) == 1
  v = axis;
  res = 100;
  yrange = v(4) - v(3);
  xrange = v(2) - v(1);
  r = v(1):(xrange/res):v(2);
  p = exp(logProb(obj, r));
  %h = plot(r, p*yrange + v(3), color);
  h = plot(r, p, color);
  set(h, 'Tag', 'uniform_density');
else
  % draw a box defined by the first two dimensions
  a = obj.a(1:2);
  b = obj.b(1:2);
  h = line([a(1) a(1) b(1) b(1); a(1) b(1) a(1) b(1)], ...
           [a(2) a(2) b(2) b(2); b(2) a(2) b(2) a(2)]);
  set(h, 'Color', color);
  set(h, 'Tag', 'uniform_density');
end
