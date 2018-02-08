function density = posterior_predict(obj)
% Returns the posterior predictive distribution based on the data
% used to train obj.

p = (obj.counts + get_a(obj.prior)) ./ (obj.n + sum(get_a(obj.prior)));
% the predictive density is given a prior so that it can be further trained
density = multinomial_density(p, obj.block_size, get_posterior(obj));
