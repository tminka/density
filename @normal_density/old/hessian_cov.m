function h = hessian_cov(obj, data, weight)
% Returns the Hessian of sum_i weight(i)*logProb(data(:, i))

dx = data - repeatcol(obj.mean, cols(data));
if nargin > 2
  wdx = dx .* repeatrow(weight, rows(data));
  n = sum(weight);
else
  wdx = dx;
  n = cols(data);
end
ic = inv(obj.cov);
d = duplication(rows(ic));

if 1
  % general case
  icdx = ic*wdx*dx'*ic;
  h = d'*(n/2*kron(ic, ic) - kron(ic, icdx))*d;
else
  % when cov = wdx*dx'
  h = -n/2*d'*kron(ic,ic)*d;
end
