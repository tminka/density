function plot(obj, color)

if nargin < 2
  color = 'g';
end

row = (rows(obj.a) == 1);

inc = 0.01;
if length(obj.a) == 2
  % Beta distribution
  r = 0:inc:1;
  if row
    r = r';
  end
  p = exp(logProb(obj, r));
  %sum(p)*inc
  h = plot(r, p, color);
  set(h, 'Tag', 'dirichlet_density');
elseif length(obj.a) == 3
  inc = 0.02;
  r = 0:inc:1;
  x = lattice([0 inc 1; 0 inc 1]);
  bad = find(col_sum(x) > 1);
  p = exp(logProb(obj, x));
  p = real(p);
  p(bad) = nan;
  s = length(r);
  p = reshape(p, s, s);
  h = mesh(r, r, p);
  view(0, 85);
  rotate3d on;
  colormap('hsv');
  axis tight;
  set(h, 'Tag', 'dirichlet_density');
end
