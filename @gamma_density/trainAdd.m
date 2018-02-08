function [obj, likelihood] = trainAdd(obj, x, weight)
% x is a matrix of columns or cell array.
% weight is a row vector.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

if nargin < 3
  weight = ones(1, cols(x));
end

obj.temp_sum = obj.temp_sum + x * weight';
obj.temp_log_sum = obj.temp_log_sum + log(x) * weight';
obj.n = obj.n + sum(weight);

if nargout > 1
  likelihood = sum(logProb(obj, x));
end
