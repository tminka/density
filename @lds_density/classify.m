function [means, vars, covs, likelihood] = classify(obj, x)
% x is a single observation sequence; either a cell row or matrix.
% means and vars run from time 1 to cols(x).
% covs runs from time 1 to cols(x)-1.
% The columns of vars and covs are vectorized square matrices.
% means(t) is the mean of the state estimate at time t.
% vars(t) is the variance of the state estimate at time t.
% covs(t) is the covariance of the state estimate at time t with time t+1.
% likelihood is the same as logProb(obj, x).

len = cols(x);

% forward pass (same as in logProb)
m = get_mean(obj.prior_state);
v = get_cov(obj.prior_state);
for t = 1:len
  [xm, xv] = output_density(obj.emission_density, m, v(:));
  xv = reshape(xv, rows(xm), rows(xm));
  if isa(x, 'cell')
    xt = x{t};
  else
    xt = x(:, t);
  end
  z(t) = mvnormpdfln(xt, xm, [], xv);
  
  % the rest is not needed on the last step (unless we're doing prediction)
  
  % gain matrix
  emission_matrix = get_prediction_matrix(obj.emission_density);
  k = v * emission_matrix' * inv(xv);
  % corrected state mean
  m = m + k*(xt - xm);
  % corrected state cov
  v = (eye(size(v)) - k * emission_matrix) * v;
  
  alpha_mean(:, t) = m;
  alpha_cov(:, t) = v(:);
  
  if(t == len)
    break
  end
  
  [m, v] = output_density(obj.transition_density, m, v(:));
  v = reshape(v, rows(m), rows(m));
end
likelihood = sum(z);

% backward pass
%covs(:, len) = zeros(prod(size(v)), 1);
for t = len:-1:2
  means(:, t) = m;
  vars(:, t) = v(:);
  
  [mp, vp] = output_density(obj.transition_density, ...
                            alpha_mean(:, t-1), alpha_cov(:, t-1));
  vp = reshape(vp, rows(mp), rows(mp));
			
  % gain matrix
  alpha_v = reshape(alpha_cov(:, t-1), size(v));
  j = alpha_v * get_prediction_matrix(obj.transition_density)' * inv(vp);
  covs(:, t-1) = vec(j*v);
  
  % corrected state mean
  m = alpha_mean(:, t-1) + j*(m - mp);
  % corrected state variance
  v = alpha_v + j*(v - vp)*j';
end
means(:, 1) = m;
vars(:, 1) = v(:);
