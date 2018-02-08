function [obj, likelihood] = trainAdd(obj, x, weight)
% x is a matrix of columns or cell array.
% Each column of x is input followed by output, i.e.
%   rows(x) = rows(obj.theta) + 1
% weight is a row vector.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

if nargin < 3
  weight = ones(1, cols(x));
end

obj.weight = [obj.weight weight];
obj.data = [obj.data x];

if nargout > 1
  likelihood = sum(logProb(obj, x));
end
