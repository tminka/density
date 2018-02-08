function obj = multinomial_density(p, block_size, prior)
% MULTINOMIAL_DENSITY  Multinomial density.
%    MULTINOMIAL_DENSITY(p) returns a multinomial density with parameter
%    vector p.

p = p(:);
if nargin < 3
  % uniform prior (informative)
  prior = dirichlet_density(ones(size(p)));
end
p = p/sum(p);
s = struct('p', p, 'prior', prior, 'counts', 0, 'n', 0, ...
    'block_size', block_size);
obj = class(s, 'multinomial_density');
