function p = logProb(obj, data)
% data is a cell row (or either cell rows or matrices).

for j = 1:cols(data)
  x = data{j};

  % precompute the data probabilities
  % loop states
  for i = 1:length(obj.weights)
    c = obj.components{i};
    q(i, :) = logProb(c, x);
  end

  % forward recursion only (same as in classify)
  len = cols(x);
  alpha = obj.weights;
  for t = 1:len
    alpha = log(alpha) + q(:, t);
    % s is the logarithm of the sum of alphas
    s = logSum(alpha);
    alpha = exp(alpha - s);
    z(t) = s;
    alpha = obj.transitions * alpha;
  end
  p(j) = sum(z);
end
