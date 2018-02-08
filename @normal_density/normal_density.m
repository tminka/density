function obj = normal_density(mean, cov, n)
% NORMAL_DENSITY   Multivariate Gaussian density.
%    NORMAL_DENSITY(D) returns a multivariate Gaussian density with
%    dimensionality D.  The mean is 0 and the covariance matrix is eye(d).
%    NORMAL_DENSITY(MEAN, COV) returns a Gaussian with the given
%    parameters.
%    If mean = NaN then the density is improper but can be used as a prior.

% Written by Tom Minka

if nargin < 3
  n = 0;
end
if nargin < 2
  d = mean;
  mean = zeros(d, 1);
  cov = eye(d);
else
  d = rows(cov);
end
% Noninformative prior
prior = normal_wishart_density(zeros(d, 1), 0, zeros(d), 0);

% obj.n is the number of samples used to train the density.
% This is useful for computing posterior distributions.
s = struct('mean', mean, 'cov', cov, 'icov', [], 'n', n, 'prior', prior, ...
    'cov_type','','temp_mean', [], 'temp_cov', []);
obj = class(s, 'normal_density');
