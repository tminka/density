% two-dimensional case

n = 10;

if 0
if 0
  if 1
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
  train1 = randnorm(n,-ones(2, 1)/2, [], v);
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

obj = probit_density(zeros(rows(data), 1)/10);
obj = set_prior(obj, set_cov(get_prior(obj), 1e+4));

obj = train(obj, data);
figure(1)
draw(obj,'g')

% number of errors
sum(exp(logProb(obj, data)) <= 0.5)

% sum(logProb(obj, data))

if 0
  % plot the posterior
  v = get_w(obj);
  h = max(abs(v));
  r1 = v - 2;
  r2 = v + 2;
  inc = (r2-r1)/20;
  
  figure(2);
  plot_posterior(obj, data, r1(1):inc(1):r2(1), r1(2):inc(2):r2(2));
end
