function obj = trainKL(obj, density)
% Returns the normal density that minimizes KL-divergence to the given density.

d = length(obj.mean);
x = [obj.mean; vec(obj.cov)];
fmins('gaussian_KL', x, [], [], d, density);
obj = normal_density(x(1:d, :), reshape(x((d+1):length(x)), d, d));
