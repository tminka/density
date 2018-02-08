function g = gradient_mean(obj, data, weight)
% Returns the gradient of sum_i weight(i)*logProb(data(:, i))
% If weight = 1, returns one gradient per column.

dx = data - repeatcol(obj.mean, cols(data));
if nargin < 3
  % weight is implicitly a vector of ones
  weight = ones(1, cols(data));
end
g = inv(obj.cov) * (dx * weight');
