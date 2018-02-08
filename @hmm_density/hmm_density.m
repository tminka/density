function obj = hmm_density(transitions, weights, varargin)
% HMM_DENSITY   Finite-state Hidden Markov model.
%    HMM_DENSITY(transitions, weights, density1, density2, ...)
%    returns an HMM with prior weights given by the second argument.
%    transitions(to, from) is the transition matrix. sum(transitions) == ones.

% A sample from this density is a matrix of arbitrary width.

% Make the weights sum to 1.
weights = weights / sum(weights);
weights = weights(:);

s = struct('transitions', transitions, 'weights', weights, ...
           'components', {varargin}, 'temperature', 1, ...
	   'n', 0);
obj = class(s, 'hmm_density');
