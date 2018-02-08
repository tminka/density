function p = logProb(obj, x, covs)
% x is a matrix of columns or cell array.
% Each column of x is input followed by output, i.e.
%   rows(x) = cols(obj.prediction_matrix) + rows(obj.prediction_matrix).
% covs is an optional matrix of vectorized covariances for each column.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

xd = cols(obj.prediction_matrix);
yd = rows(obj.prediction_matrix);
% the outputs
yi = (xd+1):(xd+yd);
y = x(yi, :);
% the inputs
xi = 1:xd;
x = x(xi, :);
% subtract the prediction from the output
y = y - obj.prediction_matrix * x;

% the result is Gaussian with mean obj.offset and covariance obj.cov.
if nargin < 3
  p = mvnormpdfln(y, obj.offset, [], obj.cov);
else
  % put each cov through the linear transformation
  n = cols(x);
  for i = 1:n
    c = reshape(covs(:, i), xd+yd, xd+yd);
    xc = c(xi, xi);
    xyc = c(xi, yi);
    yc = c(yi, yi);
    c = yc + obj.prediction_matrix * xc * obj.prediction_matrix' ...
	- 2*obj.prediction_matrix * xyc;
    covs(:, i) = c(:);
  end
  p = gauss_logProb(y, obj.offset, obj.cov, covs);
end
