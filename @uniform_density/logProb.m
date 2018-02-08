function p = logProb(obj, x)
% x is a matrix of columns or cell array.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

if isinf(obj.a) | isinf(obj.b)
  p = ones(1, cols(x))*obj.logp;
else
  p = repeatcol(-log(obj.b-obj.a), cols(x));
end
i = find(x < obj.a | x > obj.b);
p(i) = -Inf;
