function density = posterior_predict(obj)
% Returns the posterior predictive distribution based on the data
% used to train obj.

if strcmp(class(obj.prior), 'normal_density') & isnan(get_mean(obj.prior))
  density = normal_density(obj.mean, obj.cov * (obj.n + 1)/obj.n);
elseif strcmp(class(obj.prior), 'normal_wishart_density')
  density = t_density(obj.mean, obj.cov * (obj.n + 1), obj.n + 1 + get_n(obj.prior));
else
  % can't handle it
  error('posterior_predict: cannot handle that prior');
end

