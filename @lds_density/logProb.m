function [p, means] = logProb(obj, data)
% data is a cell row (or either cell rows or matrices).

for j = 1:cols(data)
  x = data{j};

  % forward recursion only (same as in classify)
  len = cols(x);
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

    if nargout > 1
      means(:, t) = m;
    end
    
    [m, v] = output_density(obj.transition_density, m, v(:));
    v = reshape(v, rows(m), rows(m));
  end
  p(j) = sum(z);
end
