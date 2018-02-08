function h = hessian_mean(obj, data, weight)
% Returns the Hessian of sum_i weight(i)*logProb(data(:, i))

% for a Gaussian, the Hessian doesn't depend on the data
if nargin < 3
  h = -inv(obj.cov)*cols(data);
else
  h = -inv(obj.cov)*sum(weight);
end
