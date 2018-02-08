function p = logProb(obj, x)

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end

p = -abs((x-obj.mean)/obj.c).^obj.b;
p = p + log(obj.b/2/obj.c) - gammaln(1/obj.b);
