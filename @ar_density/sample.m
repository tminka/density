function x = sample(obj, n)
% Returns a sequence of length n (matrix with n columns).
% The meaning of n is different than for other densities.
% Alternatively, n can be a sequence of auxiliary data.

if nargin < 2
  n = 1;
end

if length(n) > 1
  aux = n;
  n = cols(aux);
  use_aux = 1;
else
  use_aux = 0;
end

% initial sequence
s = sample(obj.initial_density);

k = obj.degree;
d = length(s)/k;
x(:, 1:k) = reshape(s, d, k);
for t = (k+1):n
  if use_aux
    x(:, t) = sample(obj.prediction_density, [aux(:,t); s]);
  else
    x(:, t) = sample(obj.prediction_density, s);
  end
  s(1:d) = [];
  s = [s; x(:,t)];
end
