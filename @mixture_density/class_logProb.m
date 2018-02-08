function p = class_logProb(obj, x)

% the last row is the class index
c = x(rows(x), :);
x = x(1:(rows(x)-1), :);

p = -Inf*ones(1, cols(x));
for i = 1:length(c)
  if obj.weights(c(i)) > 0
    p(i) = logProb(obj.components{c(i)}, x(:, i)) + log(obj.weights(c(i)));
    p(i) = p(i) - logProb(obj, x(:, i));
  end
end
