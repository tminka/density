function p = logProb(obj, x)
% x is a single matrix or cell array of matrices.

% force it to be a cell
notacell = 0;
if ~isa(x, 'cell')
  notacell = 1;
  x = num2cell(x);
end

d = rows(obj.s);
p = zeros(size(x));
if obj.inverse
  for i = 1:length(x)
    p(i) = -0.5*trace(obj.s / x{i});
  end
else
  for i = 1:length(x)
    p(i) = -0.5*trace(obj.s * x{i});
  end
  if 0
    % e is the collection of vectorized products of icov and vtrans(x(i))
    e = kron(eye(d), obj.s) * x;
    % the trace is sum of particular rows
    i = 1:(d+1):rows(e);
    p = col_sum(e(i, :));
  end
end

if obj.n > d-1
  % normalization constant (doesn't depend on x)
  p = p + obj.n/2*logdet(obj.s);
  p = p - wishart_z(obj.n, d) - d*obj.n/2*log(2);
else
  warning('density is improper')
end

dc = zeros(size(x));
for i = 1:length(x)
  if ~isposdef(x{i})
    dc(i) = -Inf;
  else
    dc(i) = logdet(x{i});
  end
end
if obj.inverse
  p = p - (obj.n + d + 1)/2*dc;
else
  p = p + (obj.n - d - 1)/2*dc;
end
