function h = plot(obj, color)

if nargin < 2
  color = 'b';
end
h = bar(obj.p);
set(h, 'FaceColor', 'none', 'EdgeColor', color);
