function x = sample(obj, n)
% Returns a sequence of length n.
% The meaning of n is different than for other densities.

if nargin < 2
  n = 1;
end

% initial state
s = sample(obj.weights);

for t = 1:n
  c = obj.components{s};
  x(:, t) = sample(c);
  p = obj.transitions(:, s);
  s = sample(p);
end
