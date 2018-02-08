function g = likelihood_gradient(obj, data, weight, gradient_func)
% Returns the gradient of sum_i weight(i)*logProb(data(:, i))
% The gradients for the components are concatenated vertically.

g = [];
mbr = classify(obj, data);
if nargin > 2 & (weight ~= 1)
  mbr = mbr .* repeatrow(weight, length(obj.weights));
end
if nargin < 4
  gradient_func = 'likelihood_gradient';
end
for i = 1:length(obj.weights)
  c = obj.components{i};
  if weight == 1
    gi = feval(gradient_func, c, data, 1);
    gi = gi .* repeatrow(mbr(i, :), rows(gi));
  else
    gi = feval(gradient_func, c, data, mbr(i, :));
  end
  g = [g; gi];
end
