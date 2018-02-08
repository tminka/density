function z = chebyshev_embedding(x, k)
% Returns z(i, j) = T(i, x(j)), where i = 1..k.
% See orthopoly[T] in maple.

z(1,:) = ones(1, cols(x));
z(2,:) = x;
for i = 3:(k+1)
  z(i,:) = 2*x.*z(i-1,:) - z(i-2,:);
end
z = z(2:(k+1), :);
