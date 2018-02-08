function data = sample(obj, n)

if nargin < 2
  n = 1;
end

data = dirichlet_sample(obj.a, n);
