function obj = gen_exp_density(m, b, c)
% GEN_EXP_DENSITY   Generalized exponential density.
%    GEN_EXP_DENSITY(m, b, c) returns the density
%    p(x) = b/2/c/gamma(1/b)*exp(-abs((x-m)/c)^b)

s = struct('mean', m, 'b', b, 'c', c);
obj = class(s, 'gen_exp_density');
