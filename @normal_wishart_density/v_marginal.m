function density = v_marginal(obj)

density = wishart_density(obj.s, obj.n, 'inverse');
