function p = logit_logProb(theta, obj, data)

obj = set_theta(obj, theta);
p = -sum(logProb(obj, data));
