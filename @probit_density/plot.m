function h = plot(obj, color)

if nargin < 2
  color = 'm';
end

if length(obj.w) == 1
  v = axis;
  x1 = v(1);
  x2 = v(2);
  inc = (x2-x1)/50;
  r = x1:inc:x2;
  h = plot(r, exp(logProb(obj, r)), color);
  set(h, 'Tag', 'probit_density');
  return
end

if length(obj.w) > 2
  b = obj.w(1);
  m = obj.w(2);
  a = -obj.w(3);
elseif length(obj.w) == 2
  b = 0;
  m = obj.w(1);
  a = -obj.w(2);
end
h = draw_line_clip(m,b,a);
set(h, 'Color', color, 'Tag', 'probit_density');
