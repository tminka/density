function p = prior_theta_logProb(obj, vs)

if strcmp(obj.prior_type, 'uniform')
  % uniform prior
  p = zeros(1, cols(vs));
  return
end

if strcmp(obj.prior_type, 'gaussian')
  % Gaussian prior
  d = rows(vs);
  p = mvnormpdfln(vs, zeros(d,1), 'inv', obj.prior_icov);
  return
end

if 0
  % Laplace density approximation
  d = length(obj.theta);
  m = zeros(d, 1);
  a = inv(obj.data * obj.data');
  v = outer(obj.data, obj.data) * safe_sum(obj.data .* (a*obj.data))';
  v = v * (2 - (1 - obj.e)^2)/4;
  v = reshape(v, d, d);
  vs = v*vs;
  p = -safe_sum(abs(vs))/2;
  return
end

% Jeffreys prior
for i = 1:cols(vs)
  obj.theta = vs(:, i);
  s = 1 ./ (1 + exp(-obj.theta' * obj.data));
  w = s .* (1-s);
  if obj.e == 0
    p(i) = 0.5*log(det(obj.data * diag(w) * obj.data'));
  else
    % when e == 1, w = 0 which causes warnings later
    w = w * (1 - obj.e);
    w = w .* w;
    pp = (exp(logProb(obj, obj.data)) + 1e-4);
    pp = pp .* (1 - exp(logProb(obj, obj.data)) + 1e-4);
    w = w ./ pp;
    if 1 | strcmp(obj.e_type, 'fixed')
      he = 1;
    else
      u = (0.5 - s) .^ 2;
      he = sum(u ./ pp);
      w = w .* (1 - u / he);
    end
    p(i) = 0.5*log(det(obj.data * diag(w) * obj.data'));
    p(i) = p(i) + 0.5*log(he);
  end
end
