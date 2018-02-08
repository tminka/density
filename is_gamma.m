function p = is_gamma(data)
% IS_GAMMA(data) returns the log-probability that data comes from some Gamma
% distribution.

n = cols(data);
if n == 1
  p = -log(data);
  return
end

l = sum(log(data));
s = n * log(sum(data)/n) - l;

p = log(2*pi) - (n+1)/2 * log(2*pi*s) - l;
p = p + gammaln((n+1)/2) - 1/2 * log(n);
