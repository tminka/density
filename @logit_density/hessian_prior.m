function h = hessian_prior(obj, data)
% data is d x n

if strcmp(obj.prior_type, 'uniform')
  % uniform prior
  h = zeros(length(obj.theta));
  return
end

if strcmp(obj.prior_type, 'gaussian')
  % Gaussian prior
  h = -obj.prior_icov;
  return
end

% Jeffreys prior
s = 1 ./ (1 + exp(-obj.theta' * data));
w = s .* (1 - s);

if obj.e == 0
  u = w .* (1 - 2*s);
  t = w .* (1 - 6*s + 6*s.^2);
else
  p = exp(logProb(obj, data));
  pp = p .* (1 - exp(logProb(obj, data))) + 1e-4;
  w = (1 - obj.e) .* w;
  b = w ./ pp;
  u = 2*(1 - 2*s) - b.*(1 - 2*p);
  if 1
    t = 4*(1 - 5*s + 5*s.*s);
    t = t - 5*b.*(1 - 2*s).*(1 - 2*p);
    t = t + 2*b.*b.*(1 - 3*p + 3*p.*p);
  else
    t = u .* u + b.*b.*(1 - 3*p + 3*p.*p);
    t = t - b.*(1 - 2*s).*(1 - 2*p);
    t = t - 4*s.*(1-s);
  end
  w = w .* w ./ pp;
  u = w .* u;
  t = w .* t;
end

% this code makes heavy use of outer.m in order to be as efficient as possible

%a = inv(data*diag(w)*data');
r = rows(data);
%keyboard
k = outer(data, data);
a = reshape(k*w', r, r);
a = inv(a);
% d is the diagonal of data'*a*data
d = col_sum(data .* (a*data));
d = d .* t;

if 8*rows(data)^4 > 1e6
  error('cannot handle that many dimensions')
end
x = outer(k, data)*u';
x = reshape(x, r^2, r);
h = reshape(k*d', r, r);
h = h - x'*kron(a, a)*x;
h = h/2;
