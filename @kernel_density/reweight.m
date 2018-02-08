function obj = reweight(obj, x, weight)

% find the index
for i = 1:cols(obj.centers)
  if obj.centers(:, i) == x
    break
  end
end
obj.temp_weights(i) = weight;

% Normalize weights
obj.weights = obj.temp_weights;
if sum(obj.weights) > 0
  obj.weights = obj.weights / sum(obj.weights);
end
