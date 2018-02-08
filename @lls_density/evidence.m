function p = evidence(obj)
% Returns the log-probability of data under the prior,
% ignoring the current parameter values (the parameters are integrated out).
% The data used to train the parameters is used.

[d,m] = size(obj.prediction_matrix);
n = obj.n;
s = obj.syy - obj.prediction_matrix * obj.syx';

if strcmp(obj.cov_type, 'fixed')
  if ~isobject(obj.prior)
    if isfinite(obj.alpha)
      r = obj.alpha/(obj.alpha+1);
    else
      r = 1;
    end
    p = 1/2*(m*d*log(r) - n*logdet(2*pi*obj.cov) - trace(s/obj.cov));
  else
    p = 1/2*(d*logdet(get_k(obj.prior)) - d*logdet(obj.sxx) ...
	- n*logdet(2*pi*obj.cov) - trace(s/obj.cov));
  end
else
  if isa(obj.prior, 'normal_wishart_density')
    n0 = get_n(obj.prior);
    s0 = get_s(obj.prior);
    p = 1/2*(d*logdet(get_k(obj.prior)) - d*logdet(obj.sxx) ...
	+ n0*logdet(s0) - n*logdet(s + s0));
  else
    n0 = obj.n0;
    if isfinite(obj.alpha)
      r = obj.alpha/(obj.alpha+1);
    else
      r = 1;
    end
    if 1
      p = 1/2*(m*d*log(r) + n0*d*log(n0) - n*logdet(s + n0*eye(d)));
    else
			% another way of writing the same thing
      p = 1/2*(m*d*log(r) - (n-n0)*d*log(n0) - n*logdet(s/n0 + eye(d)));
    end
  end
  p = p - (n-n0)*d/2*log(pi);
  for i = 1:d
    p = p + gammaln((n+1-i)/2) - gammaln((n0+1-i)/2);
  end
end
