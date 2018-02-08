function p = kernel_logProb(x, centers, width, weights, prior)

if nargin < 4
  weights = ones(cols(centers), 1)/cols(centers);
end

i = find(weights == 0);
centers(:, i) = [];
weights(i) = [];

if isempty(centers)
  p = prior*ones(1, cols(x));
  return
end

warning off

d = sqdist(centers, x);
v = -2*width^2;
e = d/v + repmat(log(weights), 1, cols(x));
k = rows(x)/2*log(2*pi) + log(width);
p = logsumexp(e) - k;

warning on
