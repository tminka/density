% path('/u/tpminka/matlab/toolbox/stats', path)

obj = gamma_density(3, 2);
disp(obj);

%data = sample(obj, 100);
data = rand(1, 100);
figure(1);
clf;
plot(data, 1:cols(data), '.');
draw(obj);

is_exponential(data)
is_gamma(data)
is_gaussian(data)

if 0
  clf;
  r = 0:0.1:20;
  plot(r, exp(logProb(obj, r)), '-');
  xlabel('x');
  ylabel('p(x)');
  % print -dps2 gamma.ps
end

obj = train(obj, data);
disp(obj);

if 0
  % compare to method of moments estimates
  xbar = mean(data);
  s2 = var(data);
  
  bhat = s2./xbar;
  ahat = xbar./bhat;
  disp('[ahat bhat] = ');
  disp([ahat bhat]);
  
  % compare to Matlab's fit
  g = gamfit(data)
end

obj = gamma_density(3, 2, 5);

if 1
  figure(1);
  r = 0.01:0.1:20;
  plot(r, exp(posterior_predict_logProb(obj, r)), '-', ...
       r, exp(logProb(obj, r)), '--');
  xlabel('x');
  ylabel('p(x)');
  legend('Posterior prediction', 'Gamma(3, 2)');
  % print -dps2 predict.ps
end

%plot(exp(posterior_logProb(obj, 3, 1.9:0.01:2.1)));
%plot(exp(posterior_logProb(obj, 2.9:0.01:3.1, 2)));

if 1
  figure(2);
  r = 0.01:0.1:15;
  pos = a_posterior(obj);
  p1 = a_posterior_logProb(obj, r);
  p1 = p1 - logSum(p1);
  p1 = exp(p1) * 10;
  p2 = exp(logProb(pos, r));
  plot(r, p1, '-', r, p2, '--');
  axis([0 10 0 0.3]);
  xlabel('a');
  ylabel('p(a)');
  legend('Exact posterior', 'Approximate posterior');
  % print -dps2 a_posterior.ps
end

if 1
  r = 20;
  r1 = 0.001:(6/r):6;
  r2 = 0.001:(6/r):6;
  [xx, yy] = meshgrid(r1, r2);
  p = posterior_logProb(obj, vec(xx)', vec(yy)');
  p = exp(reshape(p, r, r));
  figure(4);
  if 1
    mesh(r1, r2, p);
    rotate3d on;
    axis tight;
    view(50, 60)
    % print -dps2 joint_mesh.ps
  else
    contour(r1, r2, p, 5);
    % print -dps2 joint_contour.ps
  end
  xlabel('a');
  ylabel('b');
  zlabel('p(a, b | x)');
end
