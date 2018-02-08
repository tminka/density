obj = normal_density(4, 1)

if 0
% answer should be 0.3989
exp(logProb(obj, 4))
end

if 0
  data = rand(1, 1000)*10;
  % this number should be 0
  logSum(logProb(obj, data)') - log(cols(data)) + log(10)
  sum(exp(logProb(obj, data)'))/length(data)*10
end

data = sample(obj, 10);
figure(1);
plot(data, ones(1, cols(data)), '.');
draw(obj);

if 0
% these numbers should be approximately equal
sum(logProb(obj, data))/cols(data)
logProb(obj, 4, 1)
end

obj = train(obj, data)

if 0
% answer should have mean = 4 and cov = 4.5
obj = train(obj, [2 6], ones(1, 2)*1000, [0.5 0.5]);
disp(obj);
end

if 0
n = 25;
obj = normal_density(0, 1, n);
axis([-4 4 0 1]);
plot(obj);
end

if 0
  predict = posterior_predict(obj);
  figure(2);
  r = 0:0.05:8;
  plot(r, exp(logProb(predict, r)), '-', r, exp(logProb(obj, r)), '--')
  xlabel('x');
  ylabel('p(x)');
  legend('Predictive', 'ML', 0);
  % print -dps2 predict.ps
end

if 0
  m_post = mean_posterior(obj);
  n_post = normal_density(4, 1/cols(data));
  figure(3);
  r = 0:0.05:8;
  plot(r, exp(logProb(m_post, r)), '-', r, exp(logProb(n_post, r)), '--')
  xlabel('mean');
  ylabel('p(m | x)');
  legend('T', 'Normal', 0);
  % print -dps2 mean_posterior.ps
end

if 0
cov_post = cov_posterior(obj);
n = cols(data);
slice = wishart_density(n, n+1, 'inverse');
figure(3);
r = 0.01:0.01:4;
plot(r, exp(logProb(cov_post, r)), '-', r, exp(logProb(slice, r)), '--')
xlabel('variance');
ylabel('p(v | x)');
legend('Integral over m', 'Slice through m = 0');
% print -dps2 variance_posterior.ps

if 0
  x = sample(covd, 1000);
  figure(5);
  hist(1./x);
end
end

if 0
  r = 20;
  r1 = 2.5:(3/(r-1)):5.5;
  r2 = 0.01:(3/r):3;
  [xx, yy] = meshgrid(r1, r2);
  post = get_posterior(obj);
  p = logProb(post, [vec(xx)'; vec(yy)']);
  p = exp(reshape(p, r, r));
  figure(3);
  if 0
    mesh(r1, r2, p);
    axis tight;
    rotate3d on;
    % print -dps2 joint_mesh.ps
  else
    contour(r1, r2, p, 5);
    % print -dps2 joint_contour.ps
    if 1
      [means, covs] = sample(post, 100);
      hold on
      plot(means, covs, '.');
      hold off
    end
  end
  xlabel('mean');
  ylabel('variance');
  zlabel('p(m, v | x)');
end

if 0
  mix = posterior_mixture(obj, 50);
  figure(1);
  draw(mix);
end
