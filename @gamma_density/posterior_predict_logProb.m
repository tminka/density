function p = posterior_marginal_logProb(obj, x)

% recover the sufficient statistics from the parameter estimates
mean = obj.a * obj.b;
%s = (obj.n + 2)/2/obj.a;
s = obj.n/2/obj.a;

i = find(x <= 0);
x(i) = 1e-4;

mean2 = (x - mean)/(obj.n + 1) + mean;
s2 = (obj.n+1) * log(mean2/mean) - log(x/mean) + s;

p = -(obj.n+2)/2 * log(s2/s) - log(x) - 1/2 * log(4 * pi * s / obj.n);
