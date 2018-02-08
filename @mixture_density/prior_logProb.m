function p = prior_logProb(obj, data, scale)
% returns the log-probability of the current parameter values under the
% Jeffreys prior.  data is a set of sampling positions for the numerical
% integration and scale is a scale factor.

p = exp(logProb(obj, data));
g = likelihood_gradient(obj, data, 1);
pg = g .* repeatrow(p, rows(g));
h = scale*pg*g';
p = sqrt(det(h));
