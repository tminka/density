function [obj, likelihood] = trainAdd(obj, x, weight)
% x is a cell row.
% weight is a row vector.

n = cols(x);
if nargin < 3
  weight = ones(1, n);
end

likelihood = 0;
for i = 1:n
  if nargout > 1
    [obj, p] = trainAddOne(obj, x{i}, weight(i));
    likelihood = likelihood + p;
  else
    obj = trainAddOne(obj, x{i}, weight(i));
  end
end
