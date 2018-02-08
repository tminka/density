function obj = trainAddOne(obj, x, weight)
% x is a cell row.
% weight is a scalar.

if nargin < 3
  weight = 1;
end

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

if obj.aux_dim > 0
  % aux data is the first few rows of x
  aux = x(1:obj.aux_dim, :);
  x(1:obj.aux_dim, :) = [];
else
  aux = [];
end

k = obj.degree;
obj.initial_density = trainAdd(obj.initial_density, vec(x(:,1:k)), weight);

data = seq2lls(obj, x);
data = [aux(:, (k+1):cols(aux)); data];
obj.prediction_density = trainAdd(obj.prediction_density, data, ...
    repeatcol(weight, cols(data)));
