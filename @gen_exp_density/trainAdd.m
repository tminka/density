function obj = trainAdd(obj, x, weights)

if nargin < 3
  weights = ones(1, length(x));
end

obj.temp_data = [obj.temp_data x];
obj.temp_weights = [obj.temp_weights weights];
obj.n = obj.n + sum(weights);
