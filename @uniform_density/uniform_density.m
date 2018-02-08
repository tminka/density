function obj = uniform_density(a,b)
% UNIFORM_DENSITY  Uniform density.
%    UNIFORM_DENSITY(p) returns an improper density from -Inf..Inf
%    whose value at any point is p.
%    UNIFORM_DENSITY(a,b) returns a uniform density from a..b.
%    If a and b are vectors then the density fills the hyperrectangle.

if nargin == 1
  logp = log(a);
  a = -Inf;
  b = Inf;
else  
  logp = 0;
end
if length(a) ~= length(b)
  error('Endpoints must have the same dimensionality');
end
a = a(:);
b = b(:);
s = struct('a', a, 'b', b, 'logp', logp);
obj = class(s, 'uniform_density');
