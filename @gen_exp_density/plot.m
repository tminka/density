function plot(obj, color)

if nargin < 2
  color = 'g';
end

v = axis;
res = 100;
yrange = v(4) - v(3);
xrange = v(2) - v(1);
r = v(1):(xrange/res):v(2);
p = exp(logProb(obj, r));
h = plot(r, p, color);
set(h, 'Tag', 'gen_exp_density');
