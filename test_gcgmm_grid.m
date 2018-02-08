if ~exist('affine_constraint')
  path(path, '../align');
end

if 1
affine = 1;

% d dimensional grid of n = h * w points
d = 2;
s = 1;
h = 4;
w = 4;
n = h*w;

prototype = lattice([1 1 w; 1 1 h]);

if 1
  % random translation
  t = rand(d, 1);
else
  t = zeros(d, 1);
end

A = zeros(d, d*s);
if affine
  % random affine transformation
  A = randn(d, d*s);
  if affine == 2
    % random scaling followed by random affine
    A = randn(d, d) * scale2affine(randn(1, s), d);
  end
else
  % random scaling
  A = scale2affine(randn(1, s), d);
end
%A = eye(d);

data = A*prototype + repeatcol(t, n) + randn(d, n)/10;

% reverse the ordering
data(:, 1:n) = data(:, n:-1:1);

% drop last point
%p = p(:, 1:(n-1));

% add a new point
%p(:, n+1) = ones(d, 1);

% mutate a point
%p(:, 1) = zeros(d, 1);

end

figure(1);
clf
if d == 3
  plot3(data(1, :), data(2, :), data(3, :), 'o');
else
  plot(data(1, :), data(2, :), 'o');
end

nodes = cell(1, n);
for i = 1:n
  obj = normal_density(randn(d, 1)/100, eye(d)/2);
  obj = set_cov_type(obj, 'spherical');
  nodes{i} = obj;
end
obj = mixture_density(ones(1, n), nodes{:});

if 1
  if affine
    L = affine_constraint(prototype);
  else
    L = scaling_constraint(prototype);
  end
  obj = set_constraint(obj, L, 1e-4);
end

obj = train(obj, data);

