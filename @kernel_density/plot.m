function plot(obj, color)

if nargin < 2
  color = 'g';
end

if rows(obj.centers) > 1
  c = obj.centers;
  c(:, obj.weights == 0) = [];
  %c(:, obj.temp_weights < 1/20) = [];
  % show circles
  h = plot(c(1, :), c(2, :), ['x' color]);
  set(h, 'Tag', 'kernel_density');
  h = draw_circle(c(1:2, :), obj.width, color);
  set(h, 'Tag', 'kernel_density');
else
  v = axis;
  res = 100;
  yrange = v(4) - v(3);
  xrange = v(2) - v(1);
  r = v(1):(xrange/res):v(2);
  p = exp(logProb(obj, r));
  %h = plot(r, p*yrange + v(3), color);
  h = plot(r, p, color);
  set(h, 'Tag', 'kernel_density');
end
