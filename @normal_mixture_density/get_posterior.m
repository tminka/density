function density = get_posterior(obj, data, which)

if (nargin > 2) & strcmp(which, 'normal')
  % Returns the posterior approximation about the current parameter values,
  % which are assumed to maximize the likelihood.
  density = normal_density(vec(obj.means), inv(-likelihood_hessian(obj, data)));
  return
end

density = generic_posterior_density(obj, {data}, 'set_means');
