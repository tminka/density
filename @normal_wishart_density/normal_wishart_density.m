function obj = normal_wishart_density(m, k, s, n)
% NORMAL_WISHART_DENSITY   Posterior for the normal density.
%    NORMAL_WISHART_DENSITY(m, k, s, n) returns the normal density posterior
%    for sample mean M, precision k, scatter matrix S, and sample size N.
%    This is actually an inverse Wishart density.
%    Can be used as a noninformative prior by setting N = 0.
%    The samples are of the form [m; vec(v)].

% Written by Tom Minka

s = struct('mean', m, 'k', k, 's', s, 'n', n);
obj= class(s, 'normal_wishart_density');
