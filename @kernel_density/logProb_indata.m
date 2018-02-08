function p = logProb_indata(obj, x)
% x is a matrix of columns or cell array.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

p = kernel_logProb(x, obj.centers, obj.width, obj.weights, obj.prior);

k = rows(x)/2*log(2*pi) + log(obj.width);
if size(x) == size(obj.centers) 
  w = obj.weights';
  i = find((w > 0) & (w < 1));
  if ~isempty(i)
    p(i) = logSub(p(i), log(w(i)) - k) - log(1 - w(i));
  end
  % prior probability of a single data point
  p(find(w == 1)) = obj.prior;
elseif cols(x) == 1
  % find the index
  for i = 1:cols(obj.centers)
    if obj.centers(:, i) == x
      break
    end
  end
  c = obj.centers;
  c(:, i) = [];
  w = obj.weights;
  w(i) = [];
  p = kernel_logProb(x, c, obj.width, w, obj.prior);
end
