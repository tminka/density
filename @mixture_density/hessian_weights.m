function h = hessian_weights(obj, data, weight)
% Returns the Hessian of sum_i weight(i)*logProb(data(:, i))

mbr = classify(obj, data);
if nargin > 2
  mbr = mbr .* repeatrow(weight, length(obj.weights));
end
for i = 1:length(obj.weights)
  h(i) = -sum(mbr(i, :))/obj.weights(i);
end
h = diag(h);
