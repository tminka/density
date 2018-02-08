function g = logit_gradient_theta(theta, obj, data)

obj = set_theta(obj, theta);
g = -gradient_theta(obj, data);
