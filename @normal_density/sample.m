function x = sample(obj, n)
% This function is identical to gauss_sample.m
% n is the number of samples (optional).

if nargin < 2
  n = 1;
end
d = rows(obj.mean);
x = randn(d, n);
x = chol(obj.cov)' * x;
x = x + repmat(obj.mean, 1, n);
