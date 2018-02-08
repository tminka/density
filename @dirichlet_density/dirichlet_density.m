function obj = dirichlet_density(a)
% DIRICHLET_DENSITY(a) returns D(a(1), ..., a(K))

s = struct('a', a);
obj = class(s, 'dirichlet_density');
