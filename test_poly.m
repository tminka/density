% Example of finding the model order of a polynomial.
% This code re-samples the noise each time, so each run gives slightly different results.  Increasing n makes it more consistent.
% Written by Tom Minka

if ~exist('mvnormpdf')
	error('lightspeed (https://github.com/tminka/lightspeed/) is not in the MATLAB path')
end

r = -4:0.1:4;
n = 50;
if 1
  x = (0.5 - rand(1, n))*8;
  v = 10;
  % Rohan Baxter's polynomial
  y = 1 + 5*x - 1.25 * x.^2 + 0.15 * x.^3 + randn(1, n)*sqrt(v);
end

figure(1);
clf

ks = [1 2 3 4 5 6];
e = [];
p = [];
for i = 1:length(ks)
  k = ks(i);

  z = polynomial_embedding(x, k);
  % make a random linear transformation, to prove it doesn't matter
  %b = randn(k);
  b = eye(k);
  z = b * z;
  z = [ones(1,cols(z)); z];
  zr = polynomial_embedding(r, k);
  zr = b * zr;
  zr = [ones(1,cols(zr)); zr];

  % fit a line in the transformed space
  obj = lls_density(ones(1, rows(z)), v, 0);
  obj = set_offset_type(obj, 'fixed');
  obj = set_cov_type(obj, 'fixed');
  data = [z; y];
  obj = train(obj, data);

  % show the output in the original space
  yp = output_density(obj, zr);
  subplot(2,3,i);
  plot(x, y, 'x', r, yp);
  axis([-4 4 -50 30])
  title(['k = ' num2str(k)]);
  
  e(i) = evidence(obj);
  p(i) = sum(logProb(obj, data));
end
% print -dps2 poly_plots.ps

e = exp(e);
figure(2);
plot(ks, e, 'o', ks, e, '-');
title('Evidence')
xlabel('k')
% print -dps2 poly_evidence.ps

[best_e,best_k] = max(e);
best_k

p = exp(p);
figure(3);
plot(ks, p, 'o', ks, p, '-');
title('Likelihood')
xlabel('k')
% print -dps2 poly_like.ps

