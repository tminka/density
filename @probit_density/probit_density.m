function obj = probit_density(w)
% PROBIT_DENSITY   Linear classification density.
%    PROBIT_DENSITY(w) returns a linear classifier whose output is
%    p(y=1|x) = normcdf(w' * x)
%    If you want an offset, x should contain a dimension which is always 1.

d = rows(w);
prior = normal_density(zeros(d,1), eye(d));

s = struct('w', w, 'prior', prior, 'data', []);
obj = class(s, 'probit_density');
