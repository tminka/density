function obj = scale(obj, a)
% Returns the new density when the random variable is scaled by a.

obj = normal_density(a * obj.mean, a * obj.cov * a');
