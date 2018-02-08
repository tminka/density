function p = logProb_counts(obj, data, a)
% data is a matrix of histograms, oriented the same way as obj.a

if nargin < 3
  a = obj.a;
end
if any(a < 0)
  p = -Inf;
  return
end
row = (rows(a) == 1);

s = sum(a);
if row
  sdata = row_sum(data);
  p = zeros(rows(data),1);
  for k = 1:cols(data)
    dk = data(:,k);
    p = p + pochhammer(a(k), dk);
  end
  p = p - pochhammer(s, sdata);
else
  sdata = col_sum(data);
  for i = 1:cols(data)
    p(i) = sum(gammaln(data(:,i) + a)) - gammaln(sdata(i) + s);
  end
  p = p + gammaln(s) - sum(gammaln(a));
end
