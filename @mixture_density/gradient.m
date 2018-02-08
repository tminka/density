function g = gradient(obj, data, weight, gradient_func)
% Returns the gradient of sum_i weight(i)*logProb(data(:, i))
% The gradients for the components are concatenated vertically.

g = [];
mbr = classify(obj, data);
if nargin > 2
  mbr = mbr .* repeatrow(weight, length(obj.weights));
end
if nargin < 4
  gradient_func = 'gradient';
end
for i = 1:length(obj.weights)
  c = obj.components{i};
  g = [g; feval(gradient_func, c, data, mbr(i, :))];
end
