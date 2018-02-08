function obj = logit_density(theta, e)
% LOGIT_DENSITY   Linear classification density.
%    LOGIT_DENSITY(theta) returns a linear classifier whose output is
%    y = 1/(1 + exp(-theta' * [1; x]))
%    If you want an offset, x should contain a dimension which is always 1.

if nargin < 2
  e = 0;
end
s = struct('theta', theta, 'e', e, 'e_type', '', 'prior_type', 'uniform', ...
    'prior_icov', [], 'data', [], 'weight', []);
obj = class(s, 'logit_density');
