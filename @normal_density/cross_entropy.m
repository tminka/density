function [h, m, v] = cross_entropy(obj, other, tolerance)
% Returns h = int_x p_obj(x) log p_other(x)
% m = int_x x p_obj(x) log p_other(x)
% v = int_x xx' p_obj(x) log p_other(x)

d = rows(obj.mean);

if 0 & other == obj
  % entropy
  h = -1/2 * (d + d * log(2*pi) + log(det(obj.cov)));
  return
end

if 0 & isa(other, 'normal_density')
  % cross-entropy between Gaussians
  iv = inv(get_cov(other));
  diff = obj.mean - get_mean(other);
  h = -1/2 * (d * log(2*pi) - log(det(iv)) + ...
      trace(obj.cov * iv) + diff' * iv * diff);
  return
end

if d == 1
  % approximate E[ log p_other(x) ] via importance sampling
  inc = 5*obj.cov / 1000;
  x = (obj.mean - 4*sqrt(obj.cov)):inc:(obj.mean + 4*sqrt(obj.cov));
  q = logProb(obj, x);
  p = logProb(other, x);
  h = exp(q) * p' * inc;
  if nargout > 1
    m = x .* exp(q) * p' * inc;
    if nargout > 2
      v = (x.^2) .* exp(q) * p' * inc;
    end
  end
  return
end

% approximate E[ log p_other(x) ] via sampling from p_obj
n = 10000;
h = [];
m = zeros(d, 1);
v = zeros(d);
for i = 1:100
  data = sample(obj, n);
  q = logProb(other, data);
  h(i) = sum(q)/n;
  if nargout > 1
    m = m + (data * q')/n;
    if nargout > 2
      w = data .* repeatrow(q, d);
      v = v + w * data'/n;
    end
  end
  if (i > 2) & sqrt(var(h)/length(h))*2 < tolerance
    h = mean(h);
    m = m/i;
    v = v/i;
    return
  end
end

