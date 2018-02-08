function obj = trainAdd(obj, x, weight)
% x is a matrix of columns or cell array.
% weight is a row vector.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

obj.temp_centers = [obj.temp_centers x];
if nargin < 3
  % weight is implicitly a vector of ones.
  weight = ones(cols(x), 1);
end
obj.temp_weights = [obj.temp_weights; weight(:)];
