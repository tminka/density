% two-dimensional case

n = 10;

if 1
if 0
  if 0
    % separable data
    data = 2*rand(2, 2*n)-1;
    i = find(data(2, :) < -data(1, :));
    train1 = data(:, i);
    i = find(data(2, :) > -data(1, :));
    train2 = data(:, i);
    axis([0 1 0 1]);
    r = -20:1:0;
  else
    obj = logit_density([-1; -1]*30);
    data = sample(obj, 2*n);
    train1 = data(:, 1:n);
    train2 = -data(:, (n+1):(2*n));
  end
else
  % non-separable data
  v = eye(2);
  train1 = randnorm(n, -ones(2, 1)/2, [], v);
  train2 = randnorm(n, ones(2, 1)/2, [], v);
  % the optimal logit
  obj = logit_density([1; 1]);
  
  r = -5:0.5:5;
end

if 0
  % introduce an error
  train1 = [train1 train2(:,1)];
  train2(:,1) = [];
end

if 0
  % project onto unit circle
  train1 = train1./repmat(sqrt(sum(train1.^2)),2,1);
  train2 = train2./repmat(sqrt(sum(train2.^2)),2,1);
end

figure(1);
plot(train1(1, :), train1(2, :), 'o', train2(1, :), train2(2, :), 'x');
% black is the truth
draw(obj, 'k');

% note that we do not augment the data, so the line must go through zero.
data = [train1 -train2];

else
  clf
  figure(1);
  plot(train1(1, :), train1(2, :), 'o', train2(1, :), train2(2, :), 'x');
end

obj = logit_density(ones(rows(data), 1)/10, 0);
obj.e_type = 'fixed';
%exp(evidence(obj, data))
%return

obj = train(obj, data);
figure(1)
draw(obj,'g')

% number of errors
sum(exp(logProb(obj, data)) <= 0.5)

if 0
  % now with raised logistic
  obj = logit_density(randn(rows(data), 1), 0.4);
  obj.e_type = 'fixed';
  obj = train(obj, data);
  figure(1)
  h = draw(obj,'m')
  set(h, 'LineStyle', '--')
  % number of errors
  sum(exp(logProb(obj, data)) <= 0.5)
end

if 0
  % plot the regression solution
  data2 = [train1 train2];
  y = [ones(1,cols(train1)) -ones(1,cols(train2))];
  m = y*pinv(data2);
  b = mean(y - m*data2);
  figure(1)
  draw_line_clip(m(1),b,-m(2), 'Color', 'green')
end
%return

if 1
  % plot the posterior over theta
  v = obj.theta;
  r1 = min(v) - 2*abs(min(v));
  r2 = max(v) + 2*abs(max(v));
  r = linspace(r1,r2,50);
  
  figure(2);
  plot_posterior_theta(obj, data, r);
  %exp(evidence_theta(obj, data))/inc/inc
  if 0
    figure(5);
    post = get_posterior_theta(obj);
    plot(post, 'mesh', r);
  end
end

if 0
  % plot the posterior over angle
  figure(2)
  plot_posterior_angle(obj, data);
  hold on
  plot_margin_angle(obj,data);
  hold off
  axis([-3 -1 -1 1])
end

if 0
  r1 = -10;
  r2 = 10;
  inc = (r2-r1)/50;
  r = r1:inc:r2;
  % plot the prior
  x = ndgridmat(r,r)';
  p = prior_theta_logProb(obj, x);
  p = exp(p);
  p = reshape(p, length(r), length(r));
  figure(6);
  mesh(r, r, p);
  view(0, 85);
  rotate3d on;
  colormap('hsv');
  axis tight;
end
if 0
  % plot a slice of the prior
  r1 = -10;
  r2 = 10;
  inc = (r2-r1)/50;
  r = r1:inc:r2;
  x = [r; zeros(size(r))];
  p = prior_theta_logProb(obj, x);
  figure(6);
  plot(r, exp(p));
end
  
if 0
  % this posterior is a mixture of Beta densities
  figure(4);
  r = 0:0.01:1;
  plot_posterior_e(obj, data, r);
  if 0
    figure(6);
    post = get_posterior_e(obj);
    plot(post);
  end
  if 0
    % plot the prior
    p = prior_e_logProb(obj, r);
    figure(6);
    plot(r, exp(p));
  end
  %exp(evidence(obj, data))
end

if 0
% probability of the classifier
p1 = sum(logProb(obj, data))

% fit Gaussians
norm1 = normal_density(2);
norm1 = train(norm1, train1);
norm2 = normal_density(2);
norm2 = train(norm2, train2);
figure(1);
draw(norm1);
draw(norm2);
p2 = sum(logProb(norm1, train1)) + sum(logProb(norm2, train2))

p3 = sum(logProb(norm1, train1) - ...
    logSum(logProb(norm1, train1), logProb(norm2, train1))) + ...
    sum(logProb(norm2, train2) - ...
    logSum(logProb(norm1, train2), logProb(norm2, train2)))
end
