function obj = posterior_predict(obj, data)
% Returns the posterior predictive distribution based on the given data.
% The data originally used to train obj is ignored.
% Assumes all component densities are statistically identical.

if length(obj.weights) > 2
  error('posterior_predict only implemented for 2 component mixture');
end

proto = obj.components{1};

% Loop all partitions of the data set
[d,n] = size(data);
c = cell(1,n);
for i = 1:n
  c{i} = 0:1;
end
p = ndgridmat(c{:});
s = sum(p);
% remove undesirable partitions
if 0
  p = p(:, find((s > 0) & (s < n)));
else
  % use this when fitting variances too
  p = p(:, find((s > d) & (s < n-d)));
end
cols(p)
components = cell(1, cols(p));
for i = 1:cols(p)
  sel = p(:, i);
  head = data(:, find(sel));
  tail = data(:, find(1-sel));
  
  components{i} = posterior_predict(train(proto, head));
  w = evidence(proto, head) + evidence(proto, tail);
  % this is based on Jeffreys' prior
  w = w + gammaln(cols(head) + 0.5 + 1) - gammaln(cols(head) + 1);
  w = w + gammaln(cols(tail) + 0.5) - gammaln(cols(tail) + 1);
  weights(i) = w;
end
weights = exp(weights - logSum(weights));
obj = mixture_density(weights, components{:});
figure(3);
plot(weights);
