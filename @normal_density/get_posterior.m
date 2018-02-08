function density = get_posterior(obj)

if strcmp(class(obj.prior), 'normal_wishart_density')
  k = obj.n + get_k(obj.prior);
  m = (obj.n*obj.mean + get_k(obj.prior)*get_mean(obj.prior))/k;
  s = obj.cov*obj.n + get_s(obj.prior);
  diff = obj.mean - get_mean(obj.prior);
  s = s + (obj.n*get_k(obj.prior)/k)*(diff*diff');
  n = obj.n + get_n(obj.prior);
  density = normal_wishart_density(m, k, s, n);
elseif strcmp(class(obj.prior), 'normal_density')
  % in this case, the variance is fixed
  c1 = obj.cov/obj.n;
  if isnan(get_mean(obj.prior))
    density = normal_density(obj.mean, c1);
  else
    c2 = get_cov(obj.prior);
    density = normal_density(obj.mean, c1*inv(c1+c2)*c2);
  end
end
