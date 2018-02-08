function h = plot(obj, color)

if nargin < 2
  color = 'g';
end

v = axis;
inc = (v(2)-v(1))/100;
r = v(1):inc:v(2);
p = exp(logProb(obj, r));
h = plot(r, p, color);
set(h, 'Tag', 'normal_density');

sum(p)*inc
