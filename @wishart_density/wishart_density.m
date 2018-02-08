function obj = wishart_density(s, n, inverse)
% WISHART_DENSITY   Multivariate Chi-square density.
%    s is half the inverse of the scaling parameter, and
%    n is twice the counting parameter.
%    If inverse is true, then the result is an inverse Wishart density.

if nargin < 3
  inverse = 0;
end
if nargin < 2
  n = 0;
end

% obj.n is the number of samples used to train the density.
s = struct('s', s, 'n', n, 'inverse', inverse);
obj = class(s, 'wishart_density');
