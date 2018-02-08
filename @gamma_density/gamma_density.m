function obj = gamma_density(a, b, n)
% GAMMA_DENSITY   Gamma density; sum of IID exponentials.
%    GAMMA_DENSITY(a, b) returns a Gamma density with mean a*b.

if nargin < 3
  n = 0;
end

% obj.n is the number of samples used to train the density.
% This is useful for computing posterior distributions.
s = struct('a', a, 'b', b, 'n', n, ...
    'temp_sum', 0, 'temp_log_sum', 0);
obj = class(s, 'gamma_density');
