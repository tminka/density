function [x, states] = sample(obj, n)
% Returns a sequence of length n (matrix with n columns).
% The meaning of n is different than for other densities.

if nargin < 2
  n = 1;
end

% initial state
s = sample(obj.prior_state);

for t = 1:n
  if nargout > 1
    states(:, t) = s;
  end
  x(:, t) = sample(obj.emission_density, s);
  s = sample(obj.transition_density, s);
end
