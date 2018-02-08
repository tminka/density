function obj = mixture_density(weights, varargin)
% MIXTURE_DENSITY   Finite weighted sum of densities.
%    MIXTURE_DENSITY(weights, density1, density2, ...) returns a mixture
%    with weights given by the first argument.

% Make the weights sum to 1.
weights = weights / sum(weights);
weights = weights(:);
% uniform prior on the weights
weights_prior = dirichlet_density(ones(size(weights)));

% obj.n is the number of samples used to train the density.
% This is useful for computing posterior distributions.
s = struct('weights', weights, 'components', {varargin}, ...
           'temperature', 1, 'n', 0, 'phase', 0, 'temp_weights', [], ...
	   'train_components', 1, 'train_weights', 0, ...
	   'weights_prior', weights_prior, 'row', 0);
obj = class(s, 'mixture_density');
