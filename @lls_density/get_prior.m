function prior = get_prior(obj)

prior = obj.prior;
if ~isobject(obj.prior)
  [d,m] = size(obj.prediction_matrix);
  prior = normal_wishart_density(zeros(d,m), obj.sxx*obj.alpha, ...
      eye(d)*obj.n0, obj.n0);
end
