function x = sample(obj, n)

if nargin < 2
  n = 1;
end

% Choose a component
h = sample_hist(obj.weights, n);

row = obj.row;

x = [];
for i = 1:length(obj.weights)
  if h(i) > 0
    c = obj.components{i};
    xi = sample(c, h(i));
    if row
      x = [x; xi];
    else
      x = [x xi];
    end
  end
end
% jumble up the results
if row
  x = x(randperm(n), :);
else
  x = x(:, randperm(n));
end
