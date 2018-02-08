function e = fourier_width_cv(width, obj, r, p, weights)
% Returns the negative log-probability of a holdout set.
% Similar to kernel_width_cv.

w = window(obj, width);
old_p = p;
p = log(w * old_p);
if ~isreal(p)
  % reject this width
  e = 1/eps;
  e = 100;
  return
end

d = get_dim(obj);
k = -d*(1/2*log(2*pi) + log(width));

warning off
e = 0;
for i = 1:length(weights)
  w = weights(i);
  if w > 0
    % removing center i changes sum by -weights(i)/sqrt(2*pi)/width
    % and changes weights by 1/(1 - weights(i))
    if p(i) < k+log(w)
      % loss of precision occurred; just use eps
      d = log(eps) - log(1-w);
    else
      d = logSub(p(i), k + log(w)) - log(1 - w);
    end
    e = e - d;
  end
end
warning on
