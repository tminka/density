function p = logProb(obj, x)
% p = -log(GAMMA(a)) - a*log(b) + (a-1)*log(x) - x/b
% x is a matrix of columns or cell array.

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

i = find(x <= 0);
x(i) = 1e-4;

p = (obj.a-1)*log(x) - x./obj.b;
p = p - gammaln(obj.a) - obj.a*log(obj.b);
