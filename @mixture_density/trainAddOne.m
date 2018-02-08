function [obj, likelihood] = trainAddOne(obj, x, weight)
% likelihood is the same as sum(logProb(obj, x))
% x is a matrix of columns or cell array.
% weight is a row vector.

n = cols(x);
[mbr, likelihood] = classify(obj, x);
if nargout > 1
  likelihood = sum(likelihood);
end
if nargin > 2
  mbr = mbr .* repeatrow(weight, length(obj.weights));
  obj.n = obj.n + sum(weight);
else
  % weight is implicitly a vector of ones.
  obj.n = obj.n + n;
end
obj.temp_weights = obj.temp_weights + mbr*ones(n, 1);

% Train each component with the datum, weighted by its responsibility.
for i = 1:length(obj.weights)
  c = obj.components{i};
  obj.components{i} = reweight(c, x, mbr(i, :));
end
