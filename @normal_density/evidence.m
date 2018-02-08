function p = evidence(obj, data)
% Returns the log-probability of data under the prior,
% ignoring the current parameter values (the parameters are integrated out).
% If data is not given, the data used to train the parameters is used.

[d,n] = size(data);
m = col_sum(data')'/n;
s = data*data' - n*m*m';
if strcmp(class(obj.prior), 'normal_density') & isnan(get_mean(obj.prior))
  p = d*log(n) + n*log(det(2*pi*obj.cov)) + trace(s/obj.cov);
  p = -p/2;
elseif strcmp(class(obj.prior), 'normal_wishart_density') & ...
      (get_n(obj.prior) == 0)
  if n <= d
    p = 1;
    return
  end
  
  p = (n-1)*log(det(pi * s)) + d*log(n);
  p = -p/2;
  p = p + d*(d-1)/4 * log(2*pi);
  for i = 1:d
    p = p + gammaln((n-i)/2);
  end

else
  % can't handle it
  error('evidence: cannot handle that prior');
end
