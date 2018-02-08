function density = m_conditional(obj, v)
% Returns the density for m conditioned on the particular value v.

density = normal_density(obj.mean, v/obj.k);
