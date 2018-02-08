function h = likelihood_hessian(obj, data, weight, full)
% Returns the Hessian of sum_i weight(i)*logProb(data(:, i))
% at the current parameter values.
% The theta vector is [mean; vech(cov)]

if nargin < 4
  full = 0;
end
dx = data - repeatcol(obj.mean, cols(data));
if nargin < 3
  n = cols(data);
  hm = -inv(obj.cov)*n;
  if strcmp(class(obj.prior), 'normal_density')
    h = hm;
    return
  end
  wdx = dx;
  sdx = sum(dx')';
else
  n = sum(weight);
  hm = -inv(obj.cov)*n;
  if strcmp(class(obj.prior), 'normal_density')
    h = hm;
    return
  end
  wdx = dx .* repeatrow(weight, rows(data));
  sdx = dx * weight';
end
ic = inv(obj.cov);
d = rows(ic);
dn = duplication(d);

if 0
  % general case
  hvm = -dn'*kron(ic*sdx, ic);
  icdx = ic*wdx*dx'*ic;
  hv = dn'*(n/2*kron(ic, ic) - kron(ic, icdx))*dn;
else
  % when cov = wdx*dx'
  hvm = zeros(d*(d+1)/2, d);
  hv = -n/2*dn'*kron(ic,ic)*dn;
end

if full
  hvm = dn*hvm;
  hv = dn*hv*dn';
end

h = [hm hvm'; hvm hv];
