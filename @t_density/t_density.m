function obj = t_density(mean, cov, n)
% T_DENSITY   Multivariate Student's T density.

s = struct('mean', mean, 'cov', cov, 'n', n);
obj = class(s, 't_density');
