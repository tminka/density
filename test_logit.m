% one-dimensional case
% theta only controls the sharpness of the boundary

n = 2;

if 1
  v = 1;
  train1 = randnorm(n, -1/2, [], v);
  train2 = randnorm(n, 1/2, [], v);
  %train2 = [];
  inc = 0.1;
  r = -10:inc:10;
end

if length(train2) > 0
  figure(1)
  plot(train1, zeros(1, n), 'o', train2, zeros(1, n), 'x');
else
  figure(1)
  plot(train1, zeros(1, n), 'o');
end

data = [train1 -train2];

obj = logit_density(1/10);
obj.e_type = 'fixed';
obj = train(obj, data);

% number of errors
sum(exp(logProb(obj, data)) <= 0.5)

if 0
  % plot the regression solution
  data2 = [train1 train2];
  y = [ones(1,cols(train1)) -ones(1,cols(train2))];
  m = y*pinv(data2);
  b = mean(y - m*data2);
  figure(1)
  v = axis;
  line([v(1) v(2)], [m*v(1) m*v(2)]+b);
end
%return

if 1
  % plot the posterior over theta
  figure(2);
  plot_posterior_theta(obj, data, r);
  exp(evidence_theta(obj, data))/inc
  title('p(theta | data)')
  if 0
    figure(5);
    post = get_posterior_theta(obj);
    plot(post, 'g', r);
  end
end

if 0
  % plot the prior
  p = prior_theta_logProb(obj, r);
  p = exp(p);
  p = p ./ sum(p);
  figure(6);
  %plot(r, p);
  plot(r, log(p));
  title('p(theta)')
end
if 0
  % approximation to the prior
  s = sum(data);
  p = -log(1 + exp(-r*0.5));
  if 1
    p = exp(p);
    p = p .* (1 - p);
  else
    p = diff(diff(p))/inc/inc;
    p = [p 0 0];
  end
  %p = sqrt(abs(p));
  %p = ((r.*r)/1 + 1).^(-1);
  p = p ./ sum(p);
  figure(6);
  hold on;
  %plot(r, p, 'g');
  plot(r, log(p), 'g');
  hold off
end
