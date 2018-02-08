function obj = normal_mixture_density(means, cov)
% NORMAL_MIXTURE_DENSITY  Mixture of normals with common covariance matrix.

k = cols(means);
s = struct('means', means, 'cov', cov, 'icov', inv(cov), ...
    'weights', ones(k, 1)/k, 'train_means', 1, 'phase', 0);
obj = class(s, 'normal_mixture_density');
