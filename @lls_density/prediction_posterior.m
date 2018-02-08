function density = prediction_posterior(obj, cov)
% Returns the posterior for the prediction matrix given
% the data and the optional output covariance parameter.
% If the output covariance is not given, it is integrated out
% using the prior.

[d,m] = size(obj.prediction_matrix);
if nargin > 1
  if m > 1
    density = matrix_normal_density(obj.prediction_matrix, cov, obj.sxx);
  else
    density = normal_density(obj.prediction_matrix, cov/obj.sxx);
  end
else
  if m > 1
    density = matrix_t_density(obj.prediction_matrix, obj.n*obj.cov, ...
	obj.sxx, obj.n + m);
  else
    density = t_density(obj.prediction_matrix, obj.n*obj.cov/obj.sxx, obj.n+m);
  end
end
