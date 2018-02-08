function x = sample(obj, n)
% Sample from the distribution.
% n is the number of samples (optional).
% This routine matches Devroye, at least in the univariate case.
% The multivariate generalization comes from Tong's book.

if nargin < 2
  n = 1;
end
x = randnorm(n, zeros(size(obj.mean)), [], obj.cov);
% g is Chi with (obj.n-d) degrees of freedom
d = rows(x);
g = sqrt(gamrnd((obj.n-d)/2, ones(1, n)*2));
x = x ./ repeatrow(g, d);
x = x + repeatcol(obj.mean, n);
