function [obj, likelihood] = trainAdd(obj, x, weight, covs)
% x is a matrix of columns or cell array.
% weight is a row vector.
% covs is an optional matrix of vectorized covariances for the data points.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

if nargin > 2
  obj.temp_mean = obj.temp_mean + x * weight';
  wx = x .* repeatrow(weight, rows(x));
  obj.temp_cov = obj.temp_cov + wx * x';
  if nargin > 3
    obj.temp_cov = obj.temp_cov + reshape(covs * weight', size(obj.temp_cov));
  end
  obj.n = obj.n + sum(weight);
else
  % weight is implicitly a vector of ones.
  n = cols(x);
  obj.temp_mean = obj.temp_mean + x * ones(n, 1);
  obj.temp_cov = obj.temp_cov + x * x';
  obj.n = obj.n + n;
end

if nargout > 1
  likelihood = sum(logProb(obj, x));
end
