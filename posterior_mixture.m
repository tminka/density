function mix = posterior_mixture(obj, k)
% Returns a k-component mixture of Gaussians to approximate an integral
% over the posterior distribution for the parameters given the training data.

if 1
  
  c = sample_posterior(obj, k);
  mix = mixture_density(ones(k, 1), c{:});
  
else
  
[means, covs] = sample_posterior(obj, k);
p = posterior_logProb(obj, means, covs);
% normalize p
s = logSum(p);
p = exp(p - s);
p = ones(k, 1);

c = cell(cols(means), 1);
for i = 1:cols(means)
  cov = reshape(covs(:, i), size(obj.cov));
  c{i} = normal_density(means(:, i), cov);
end
mix = mixture_density(p, c{:});
end
