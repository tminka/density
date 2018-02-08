function g = gradient_e(obj, data, weight)

p = 1 ./ (1 + exp(-obj.theta' * data));
if nargin < 3
  weight = ones(1, cols(data));
end
g = (0.5 - p) ./ (exp(logProb(obj, data)) + 1e-4) * weight';
if 0 & cols(data) > 1
  % normalize the length of the gradient by the effective data set size.
  n = (1-p) * weight';
  g = g ./ n;
end
