function z = polynomial_embedding(x, k, include_1)
% Returns z(i, j) = x(j)^i, where i = 1..k.
% This is also called a Vandermonde matrix.

if nargin < 3
  include_1 = 0;
end
d = rows(x);
r = 1:d;
for i = double(~include_1):k
  z(r, :) = x .^ i;
  r = r + d;
end
