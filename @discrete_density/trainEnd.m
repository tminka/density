function obj = trainEnd(obj)

if 1
  % MAP estimate
  obj.p = (obj.counts + get_a(obj.prior) - 1) / ...
      (obj.n - length(obj.p) + sum(get_a(obj.prior)));
else
  % predictive estimate
  obj.p = (obj.counts + get_a(obj.prior)) / ...
      (obj.n + sum(get_a(obj.prior)));
end
