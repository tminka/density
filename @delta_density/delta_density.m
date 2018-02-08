function obj = delta_density(mean)
% DELTA_DENSITY   Nonrandom density.
%    DELTA_DENSITY(x) returns a density which is nonzero only at x.

s = struct('mean', mean);
obj = class(s, 'delta_density');
