% predictive density in nonlinear case

n = 5;
z = rand(1,n);
zs = 0:0.01:1;
%zs = -0.5:0.01:1.5;
v = 0.1;

k = 4;
t = 0:1/k:1;
if 1
  x = chebyshev_embedding(z, 4);
  xs = chebyshev_embedding(zs, 4);
elseif 0
  x = sqrt(distance(t, z));
  xs = sqrt(distance(t, zs));
elseif 1
  h = 1/100;
  x = gaussian_embedding(z, t, h);
  xs = gaussian_embedding(zs, t, h);
else
  h = 10;
  x = [];
  xs = [];
  for i = 1:cols(t)
    x(i,:) = tanh(h*(z - t(i)));
    xs(i,:) = tanh(h*(zs - t(i)));
  end
end
  

a = randn(1,rows(x));
y = a*x + randn(1,n)*sqrt(v);
figure(1)
clf
plot(z, y, 'o')
xlabel('z')
ylabel('y')

% fit a line in the transformed space
obj = lls_density(zeros(1, rows(x)), v);
obj = set_cov_type(obj, 'fixed');
obj = train(obj, [x; y]);

if 1
hold on
plot_posterior_predict(obj, 'g', xs, zs)
hold off
return
end

hold on
ys = output_density(obj, xs);
plot(zs, ys, '-');
hold off

if 0
  % this is not a good test since shrinking the width doesn't necessarily
  % improve the fit
hs = (1:20)*1e-2;
e = [];
p = [];
for i = 1:length(hs)
  x = gaussian_embedding(z, t, hs(i));
  xs = gaussian_embedding(zs, t, hs(i));
  obj = lls_density(zeros(1, rows(x)), v);
  obj = set_cov_type(obj, 'fixed');
  obj = train(obj, [x; y]);
  figure(1)
  clf
  ys = output_density(obj, xs);
  plot(z, y, 'x', zs, ys, '-');
  e(i) = evidence(obj);
  p(i) = sum(logProb(obj, [x;y]));
end
figure(2)
plot(hs, e)
figure(3)
plot(hs, p)
end
