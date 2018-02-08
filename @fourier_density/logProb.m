function p = logProb(obj, x)
% x is a matrix of columns or cell array.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

% map data into [0,1]
x = (x - obj.a) ./ repmat(obj.b - obj.a, 1, cols(x));
% conjugate to get the inverse transform
fx = conj(ft_each(obj, x));
p = real(obj.coeffs*fx);
p(find((p < eps) | (x < 0) | (x > 1))) = eps;
p = log(p);
