function g = gradient_prior(obj, data)

if strcmp(obj.prior_type, 'uniform')
  % uniform prior
  g = zeros(size(obj.theta));
  return
end

if strcmp(obj.prior_type, 'gaussian')
  % Gaussian prior
  g = -obj.prior_icov*obj.theta;
  return
end

% Jeffreys prior
s = 1 ./ (1 + exp(-obj.theta' * data));
w = s .* (1 - s);
if obj.e == 0
  u = w .* (1 - 2*s);
else
  p = exp(logProb(obj, data));
  pp = p .* (1 - p) + 1e-4;
  w = (1 - obj.e) .* w;
  b = w ./ pp;
  w = w .* w ./ pp;
  u = w .* (2*(1 - 2*s) - b.*(1 - 2*p));
end
a = inv(data*diag(w)*data');
% d is the diagonal of data'*a*data
d = col_sum(data .* (a*data));
g = data*(u .* d)'/2;
