function g = gradient_theta(obj, data, weight)
% Returns the gradient of the log-likelihood wrt theta.

s = obj.theta' * data;
p = 1 ./ (1 + exp(-s));
if obj.e == 0
  w = 1 - p;
  i = find(s > 36);
  if ~isempty(i)
    w = exp(-s);
    % this is series for 1 - exp(-w)
    w = w - w.^2/2 + w.^3/6;
  end
else
  w = (1 - obj.e) * p .* (1 - p) ./ (exp(logProb(obj, data)) + 1e-4);
end
if nargin < 3
  weight = ones(1, cols(data));
else
  w = w .* weight;
end
g = data * w';
%g = g - obj.theta*(obj.theta'*g)/(obj.theta'*obj.theta);
if 0 & cols(data) > 1
  % normalize the length of the gradient by the effective data set size.
  n = (1-p) * weight';
  g = g ./ n;
end
