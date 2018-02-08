function p = posterior_logProb(obj, as, bs)
% Returns the log-probability of each (a, b) pair, given the
% training data and the prior p(a,b) = 1/a/b.

% recover the sufficient statistics from the parameter estimates
mean = obj.a * obj.b;
s = (obj.n + 2)/2/obj.a;

p = - obj.n * mean ./ bs - as * s;
p = p + (obj.n * as) .* log(mean ./ bs) - log(bs);
p = p - obj.n * gammaln(as);

if obj.n > 1
  % normalization term
  p = p + 1/2*log(obj.n) + (obj.n + 1)/2 * log(2*pi*s) - log(2*pi);
  p = p - gammaln((obj.n+1)/2);
end
