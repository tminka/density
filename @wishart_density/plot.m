function plot(obj, color)

if nargin < 2
  color = 'g';
end

v = axis;
r = linspace(v(1),v(2),100);
h = plot(r, exp(logProb(obj, r)), color);
set(h, 'Tag', 'wishart_density');
