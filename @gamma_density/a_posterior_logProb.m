function p = a_posterior_logProb(obj, a)
% This is the true posterior, without approximation or normalization.

mean = obj.a * obj.b;
%s = (obj.n + 2)/2/obj.a;
s = obj.n/2/obj.a;

p = gammaln(obj.n * a) - obj.n * gammaln(a) - obj.n * a * log(obj.n);
p = p - s * a;
