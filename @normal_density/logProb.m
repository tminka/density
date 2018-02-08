function p = logProb(obj, x, covs)
% x is a matrix of columns or cell array.
% covs is an optional matrix of vectorized covariances for the data points.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

[d, n] = size(x);

if isnan(obj.mean)
  % improper noninformative prior for a location parameter
  p = -d/2*log(2*pi) - 1/2*logdet(obj.cov);
  p = repmat(p, 1, cols(x));
  return
end
dx = x - repmat(obj.mean, 1, n);

if obj.cov == 0
	% distribution is a point mass
	p = repmat(-Inf,1,n);
	dist = col_sum(dx .* dx);
	p(dist == 0) = 0;
	if nargin > 2
		error('obj.cov == 0')
	end
	return
end

ic = inv(obj.cov);

% Mahalanobis distance
icdx = ic*dx;
dist = col_sum(dx .* icdx);

k = logdet(ic) - d*log(2*pi);
p = (k - dist)/2;

if nargin > 2
  for i = 1:n
    cov = reshape(covs(:, i), size(ic));
    % this is \int N(x, cov) log N(obj.mean, obj.cov)
    p(i) = p(i) - 1/2*trace(cov*ic);
  end
end
