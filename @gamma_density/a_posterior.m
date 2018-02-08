function density = a_posterior(obj)

% recover the sufficient statistics from the parameter estimates
mean = obj.a * obj.b;
%s = (obj.n + 2)/2/obj.a;
s = obj.n/2/obj.a;

density = gamma_density((obj.n + 1)/2, 1/s);
