function [means, covs] = sample(obj, n)

if nargin < 2
  n = 1;
end

if obj.n == 0 | obj.k == 0
  error('Cannot sample from an improper density');
end

covd = wishart_density(obj.s, obj.n, 'inverse');
cs = sample(covd, n);
for i = 1:n
  % conditional on the covariance, the mean is Gaussian
  c = cs{i};
  covs(:, i) = vec(c);
  means(:, i) = randnorm(1, obj.mean, [], c/obj.k);
end
if nargout == 1
  means = [means; covs];
end
