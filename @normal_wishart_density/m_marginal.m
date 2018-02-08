function density = m_marginal(obj)

density = t_density(obj.mean, obj.s/obj.k, obj.n+1);
