function [y, v] = output_density(obj, x, covs)
% x is a matrix of columns or cell array.
% covs is an optional matrix of vectorized covariances for each column.
% y is the conditional mean of the output.
% v is the conditional variance of the output.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

[xd, n] = size(x);
y = obj.prediction_matrix * x + repmat(obj.offset, 1, n);

if nargout > 1
  if nargin < 3
    v = repmat(obj.cov(:), 1, n);
  else
    for i = 1:n
      xc = reshape(covs(:, i), xd, xd);
      yc = obj.cov + obj.prediction_matrix * xc * obj.prediction_matrix';
      v(:, i) = yc(:);
    end
  end
end
