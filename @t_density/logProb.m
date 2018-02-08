function p = logProb(obj, x)
% x is a matrix of columns or cell array.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

[d, n] = size(x);

if obj.n <= d
  dx = x - repmat(obj.mean, 1, n);
  warning off
  p = -1/2*log(col_sum(dx .* dx));
  warning on
  i = find(isnan(p));
  p(i) = Inf;
  return
end

ic = inv(obj.cov);

% Mahalanobis distance
dx = x - repmat(obj.mean, 1, n);
icdx = ic*dx;
dist = col_sum(dx .* icdx);

p = obj.n*log(dist + 1);

% normalizing term
p = p + logdet(obj.cov) + d*log(pi);
p = p - 2*gammaln(obj.n/2) + 2*gammaln((obj.n - d)/2);

p = -p/2;
