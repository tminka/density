function density = v_conditional(obj, m)
% Returns the density for v conditional on the particular value m.

s = obj.s + obj.k * (m - obj.mean) * (m - obj.mean)';
density = wishart_density(s, obj.n + 1, 'inverse');
