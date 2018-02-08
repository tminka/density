function obj = trainAdd(obj, data, weight)
% data is a row vector of observations

if nargin < 3
  weight = ones(1, length(data));
end

for k = 1:length(obj.p)
  obj.counts(k) = obj.counts(k) + sum((data == k) .* weight);
end
obj.n = obj.n + sum(weight);
