n1 = 10;
n2 = 10;
n = n1+n2;
normal = 1;
if normal
  d = 5;
  v = randn(d);
  v = v'*v;
  norm1 = normal_density(zeros(d, 1), v);
  %v = randn(d);
  %v = v'*v;
  norm2 = normal_density(ones(d, 1)/10, v);
  
  train1 = sample(norm1, n1);
  train2 = sample(norm2, n2);
else
  data = rand(2, n);
  i = find(data(2, :) < 1-data(1, :));
  train1 = data(:, i);
  %train1 = train1(:, 1:n);
  i = find(data(2, :) > 1-data(1, :));
  train2 = data(:, i);
  %train2 = train2(:, 1:n);
  axis([0 1 0 1]);
end

figure(1);
clf
plot(train1(1, :), train1(2, :), 'o', train2(1, :), train2(2, :), 'x');
if normal
  draw(norm1);
  draw(norm2);
end

data = [ones(1, cols(train1)) -ones(1, cols(train2)); train1 -train2];

if 1
  % train a logistic classifier
  obj = logit_density(ones(rows(data), 1)/10);
  %obj = set_train(obj, 'error');
  obj = train(obj, data);
  figure(1);
  disp(obj);
  if d == 2
    draw(obj);
  end
  drawnow
  
  % compute the error rate on the training data
  err_logit_train = sum(exp(logProb(obj, data)) < 0.5)/n
end

% empirical Gaussian method %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
emp_norm1 = normal_density(rows(train1));
emp_norm1 = train(emp_norm1, train1);
emp_norm2 = normal_density(rows(train2));
emp_norm2 = train(emp_norm2, train2);

if 0
  % force equal variances (to get the Fisher discriminant)
  emp_v = (get_cov(emp_norm1) + get_cov(emp_norm2))/2;
  emp_norm1 = set_cov(emp_norm1, emp_v);
  emp_norm2 = set_cov(emp_norm2, emp_v);
end
%draw(emp_norm1);
%draw(emp_norm2);

% compute the error rate on the training data
err_emp_train = sum(logProb(emp_norm1, train1) < logProb(emp_norm2, train1)) ...
    + sum(logProb(emp_norm1, train2) > logProb(emp_norm2, train2));
err_emp_train = err_emp_train/n

% posterior prediction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 1
  post_norm1 = posterior_predict(emp_norm1);
  post_norm2 = posterior_predict(emp_norm2);
else
  % construct a mixture by sampling
  % 10 components seems sufficient for n = 10
  post_norm1 = posterior_mixture(emp_norm1, 10);
  post_norm2 = posterior_mixture(emp_norm2, 10);
end
draw(post_norm1);
draw(post_norm2);

% compute the error rate on the training data
err_post_train = sum(logProb(post_norm1, train1) < logProb(post_norm2, train1)) ...
    + sum(logProb(post_norm1, train2) > logProb(post_norm2, train2));
err_post_train = err_post_train/n

% corrected estimate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 0
  % unbiased estimate
  fixed_norm1 = set_cov(emp_norm1, get_cov(emp_norm1)*n1/(n1-1));
  fixed_norm2 = set_cov(emp_norm2, get_cov(emp_norm2)*n2/(n2-1));
  % posterior marginal approximation
  %fixed_norm1 = set_cov(emp_norm1, get_cov(emp_norm1)*(n1+1)/(n1-3));
  %fixed_norm2 = set_cov(emp_norm2, get_cov(emp_norm2)*(n2+1)/(n2-3));
else
  % force equal variances (to get the Fisher discriminant)
  emp_v = (get_cov(emp_norm1)*n1 + get_cov(emp_norm2)*n2)/n;
  fixed_norm1 = set_cov(emp_norm1, emp_v);
  fixed_norm2 = set_cov(emp_norm2, emp_v);
end

% compute the error rate on the training data
err_fixed_train = sum(logProb(fixed_norm1, train1) <= logProb(fixed_norm2, train1)) ...
    + sum(logProb(fixed_norm1, train2) >= logProb(fixed_norm2, train2));
err_fixed_train = err_fixed_train/n

% optimal discriminant %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if normal
  % since the variances are equal, the optimal discriminant is
  % the Fisher discriminant.
  a = inv(v)*(get_mean(norm2) - get_mean(norm1));
  t = (get_mean(norm2)'*inv(v)*get_mean(norm2) - ...
      get_mean(norm1)'*inv(v)*get_mean(norm1))/2;

  opt = logit_density([t; -a]);
  if d == 2
    draw(opt, 'k');
  end
else
  b = data' \ (ones(cols(data), 1)/n);
  opt = logit_density(b);
  %opt = logit_density([1; -1; -1]);
  if d == 2
    draw(opt, 'k');
  end
end
drawnow

% compute the error rate on the training data
err_opt_train = sum(exp(logProb(opt, data)) < 0.5)/n/2

% Test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n1 = 50000;
n2 = 50000;
n = n1 + n2;
if normal
  test1 = sample(norm1, n1);
  test2 = sample(norm2, n2);
else
  data = rand(2, n);
  i = find(data(2, :) < 1-data(1, :));
  test1 = data(:, i);
  i = find(data(2, :) > 1-data(1, :));
  test2 = data(:, i);
  axis([0 1 0 1]);
end

data = [ones(1, cols(test1)) -ones(1, cols(test2)); test1 -test2];

% compute the error rate
err_logit_test = sum(exp(logProb(obj, data)) < 0.5)/n

% compute the error rate
err_emp_test = sum(logProb(emp_norm1, test1) < logProb(emp_norm2, test1)) ...
    + sum(logProb(emp_norm1, test2) > logProb(emp_norm2, test2));
err_emp_test = err_emp_test/n

% compute the error rate
err_post_test = sum(logProb(post_norm1, test1) < logProb(post_norm2, test1)) ...
    + sum(logProb(post_norm1, test2) > logProb(post_norm2, test2));
err_post_test = err_post_test/n

% compute the error rate
err_fixed_test = sum(logProb(fixed_norm1, test1) < logProb(fixed_norm2, test1)) ...
    + sum(logProb(fixed_norm1, test2) > logProb(fixed_norm2, test2));
err_fixed_test = err_fixed_test/n

% compute the error rate
err_opt_test = sum(exp(logProb(opt, data)) < 0.5)/n

if normal
  % the minimum possible error rate
  m1 = a'*get_mean(norm1);
  c = a'*(get_mean(norm2) - get_mean(norm1));
  1/2*erfc((t - m1)/sqrt(2*c))
end
