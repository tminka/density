function obj = discrete_density(p, prior)
% DISCRETE_DENSITY   Discrete density.
%    DISCRETE_DENSITY(p) returns a discrete density on n = 1..length(p) where
%    n has probability p(n).

p = p(:);
if nargin < 2
  % uniform prior (informative)
  prior = dirichlet_density(ones(size(p)));
end
p = p/sum(p);
s = struct('p', p, 'prior', prior, 'counts', 0, 'n', 0);
obj = class(s, 'discrete_density');
