function h = plot(obj, color)

if nargin < 2
  color = 'm';
end

if length(obj.theta) == 1
  v = axis;
  x1 = v(1);
  x2 = v(2);
  inc = (x2-x1)/50;
  r = x1:inc:x2;
  h = plot(r, exp(logProb(obj, r)), color);
  set(h, 'Tag', 'logit_density');
  return
end

if length(obj.theta) > 2
  b = obj.theta(1);
  m = obj.theta(2);
  a = -obj.theta(3);
elseif length(obj.theta) == 2
  b = 0;
  m = obj.theta(1);
  a = -obj.theta(2);
end
h = draw_line_clip(m,b,a);
set(h, 'Color', color, 'Tag', 'logit_density');

if 0
x1range = v(2)-v(1);
x2range = v(4)-v(3);
[x1, x2] = meshgrid(v(1):(x1range)/9:v(2), v(3):(x2range)/9:v(4));
data = [vec(x1)'; vec(x2)'];
z = output_density(obj, data)';
imagesc(vtrans(z, 10));
end
