function obj = matrix_normal_density(m, v, c)
% MATRIX_NORMAL_DENSITY
%    c = [] is the same as c = eye(cols(m)).
%    This density cannot be trained.

if nargin < 4
  n = 0;
  if nargin < 3
    c = [];
  end
end

s = struct('m', m, 'v', v, 'c', c);
obj = class(s, 'matrix_normal_density');
