function p = gaussian_KL(x, d, density)
% x is of length d + d^2 = d*(d + 1)

m = x(1:d);
v = reshape(x((d+1):length(x)), d, d);
obj = normal_density(m, v);
p = cross_entropy(obj, obj) - cross_entropy(obj, density, 0.01);
