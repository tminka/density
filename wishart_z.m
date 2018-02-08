function p = wishart_z(n,d)

p = d*(d-1)/4*log(pi);
for i = 1:d
  p = p + gammaln((n + 1 - i)/2);
end
