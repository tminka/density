% nonlinear regression using feature mapping

% noisy sinewave data
limit = 8*pi;
r = 0:0.02:limit;
x = r(1:20:length(r));
v = 1/9;
y = sin(x) + randn(1, length(x))*sqrt(v);

ks = [1 4 8 12];
ks = [12 16 20 24];
ks = [22 24 26 28];
e = [];
for i = 1:length(ks)
  k = ks(i);

  figure(1);
  subplot(2, 2, i);
  plot(x, y, 'o');

if 1
  % h is a smoothness hyperparameter
  h = limit/k;
  
  % center locations
  % if there is one center on each data point, we get an interpolant
  kx = 0:h:limit;
  %kx = [1 3 5];

  % transform into RBF features
  z = gaussian_embedding(x, kx, h);
  zr = gaussian_embedding(r, kx, h);
else
  % transform into polynomial features
  % k = 4, 6, 8, 11
  z = chebyshev_embedding(x/limit, k);
  zr = chebyshev_embedding(r/limit, k);
end

% fit a line in the transformed space
obj = lls_density(ones(1, rows(z)), v);
obj = set_offset_type(obj, 'fixed');
obj = set_cov_type(obj, 'fixed');
data = [z; y];
obj = train(obj, data);

% show the output in the original space
yp = output_density(obj, zr);
hold on
plot(r, yp, 'g');
hold off
axis([-1 20 -4 4]);
title(['k = ' num2str(k)]);

e(i) = evidence(obj);

end

figure(2);
plot(ks, e, '-', ks, e, 'o');

% print -dps2 polyfit.ps
