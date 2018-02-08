function p = evidence_theta(obj, data)

d = length(obj.theta);
h = -likelihood_hessian_theta(obj, data);
h = h - hessian_prior(obj, data);
if ~isposdef(h)
  error('Hessian is not positive definite');
end
p = sum(logProb(obj, data)) + d/2*log(2*pi) - 1/2*logdet(h);
p = p + prior_theta_logProb(obj, obj.theta);
