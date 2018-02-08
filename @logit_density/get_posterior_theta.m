function density = get_posterior_theta(obj)

h = -likelihood_hessian_theta(obj, obj.data, obj.weight);
h = h - hessian_prior(obj, obj.data);
density = normal_density(obj.theta, inv(h));
