function p = logProb(obj, x)
% x is a matrix of columns or cell array.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

if obj.e == 0
  s = obj.theta' * x;
  p = -log(1 + exp(-s));
  i = find(s > 36);
  if ~isempty(i)
    % large s limit
    p(i) = -exp(-s(i));
  end
else
  p = log(obj.e/2 + (1-obj.e)./(1 + exp(-obj.theta' * x)));
end
