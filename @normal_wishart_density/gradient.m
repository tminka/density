function g = gradient(obj, means, cov, full)
% Returns the gradient of logProb(obj) at the given locations.

if nargin < 4
  full = 0;
end

dx = means - repeatcol(obj.mean, cols(means));
ic = inv(cov);
icdx = ic*dx;

gm = obj.k * icdx;

d = rows(obj.mean);
gv = -(obj.n+d+2)*ic + ic*obj.s*ic + obj.n*icdx*icdx';
gv = gv/2;
if full
  gv = vec(gv);
else
  gv = vech(gv);
end
g = [gm; repeatcol(gv, cols(gm))];
