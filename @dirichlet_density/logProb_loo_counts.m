function p = logProb_loo_counts(obj, data, a)

if nargin < 3
  a = obj.a;
end
if any(a < 0)
  p = -Inf;
  return
end
sa = sum(a);
sdata = safe_sum(data);
for i = 1:cols(data)
  p(i) = sum(data(:,i).*log(data(:,i)-1 + a));
  p(i) = p(i) - sdata(i)*log(sdata(i)-1 + sa);
end
