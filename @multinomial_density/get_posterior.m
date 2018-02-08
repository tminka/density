function density = get_posterior(obj)

density = dirichlet_density(obj.counts + get_a(obj.prior));
