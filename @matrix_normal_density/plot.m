function plot(obj, color)

if nargin < 2
  color = 'b';
end

if rows(obj.m) == 1
  s = sqrt(obj.v);
  if 0
    l = obj.m - s;
    u = obj.m + s;
  else
    l = repmat(-s, 1, cols(obj.m));
    u = repmat(s, 1, cols(obj.m));
  end
  errorbar(1:cols(obj.m), obj.m, l, u, [color 'o']);
else
  plot_dots(obj.m, color);
  draw_ellipse(obj.m, obj.v, color);
end
