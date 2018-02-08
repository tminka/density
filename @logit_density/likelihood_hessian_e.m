function h = likelihood_hessian_e(obj, data)

p = 1 ./ (1 + exp(-obj.theta' * data));
w = (0.5 - p) ./ (exp(logProb(obj, data)) + 1e-4);
h = -w*w';
