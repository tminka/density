function [obj, likelihood] = trainAdd(obj, x, weight)
% x is a matrix of columns or cell array.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

obj.data = [obj.data x];

if nargout > 1
  likelihood = sum(logProb(obj, x));
end
