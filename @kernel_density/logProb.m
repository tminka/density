function p = logProb(obj, x)
% x is a matrix of columns or cell array.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

p = kernel_logProb(x, obj.centers, obj.width, obj.weights, obj.prior);
