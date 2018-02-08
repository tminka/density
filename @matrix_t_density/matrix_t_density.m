function obj = matrix_t_density(m, v, c, n)
% MATRIX_T_DENSITY

s = struct('m', m, 'v', v, 'c', c, 'n', n);
obj = class(s, 'matrix_t_density');
