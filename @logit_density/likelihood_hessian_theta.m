function h = likelihood_hessian_theta(obj, data, weight)

p = 1 ./ (1 + exp(-obj.theta' * data));
w = p .* (1-p);
if obj.e > 0
  w = (1 - obj.e) * w ./ (exp(logProb(obj, data)) + 1e-4);
  u = 2*p-1;
  w = w .* (w + u);
end
if nargin > 2
  w = w .* weight;
end
h = -(data * diag(w) * data');
