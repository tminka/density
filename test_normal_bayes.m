function [err_ml_test, err_ub_test, err_ab_test, err_eb_test, err_opt_test] ...
    = test_normal_bayes(d, n1, n2)

n = n1+n2;

if 0
  v = ones(d) + diag(1:d);
  v1 = v;
  v2 = v;
else
  % v is sampled from W(I, d)
  v = randn(d);
  v1 = v*v';
  v = randn(d);
  v2 = v*v';
end
norm1 = normal_density(zeros(d, 1), v1);
norm2 = normal_density(ones(d, 1)/d/1e1, v2);

train1 = sample(norm1, n1);
train2 = sample(norm2, n2);

if 0
  figure(1);
  if d == 1
    plot(train1, 1:n1, 'o', train2, 1:n2, 'x');
  else
    plot(train1(1, :), train1(2, :), 'o', train2(1, :), train2(2, :), 'x');
  end
  draw(norm1);
  draw(norm2);
end

% ML %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ml_norm1 = normal_density(rows(train1));
ml_norm1 = train(ml_norm1, train1);
ml_norm2 = normal_density(rows(train2));
ml_norm2 = train(ml_norm2, train2);
if 0
  draw(ml_norm1, 'b');
  draw(ml_norm2, 'b');
end

% compute the error rate on the training data
err_ml_train = sum(logProb(ml_norm1, train1) < logProb(ml_norm2, train1)) ...
    + sum(logProb(ml_norm1, train2) > logProb(ml_norm2, train2));
err_ml_train = err_ml_train/n;

% UB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ub_norm1 = set_cov(ml_norm1, get_cov(ml_norm1)*n1/(n1-1));
ub_norm2 = set_cov(ml_norm2, get_cov(ml_norm2)*n2/(n2-1));

% compute the error rate on the training data
err_ub_train = sum(logProb(ub_norm1, train1) < logProb(ub_norm2, train1)) ...
    + sum(logProb(ub_norm1, train2) > logProb(ub_norm2, train2));
err_ub_train = err_ub_train/n;

% AB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ab_norm1 = set_cov(ml_norm1, get_cov(ml_norm1)*(n1+1)/(n1-d-1));
ab_norm2 = set_cov(ml_norm2, get_cov(ml_norm2)*(n2+1)/(n2-d-1));
if 0
  draw(ab_norm1, 'r');
  draw(ab_norm2, 'r');
end

% compute the error rate on the training data
err_ab_train = sum(logProb(ab_norm1, train1) < logProb(ab_norm2, train1)) ...
    + sum(logProb(ab_norm1, train2) > logProb(ab_norm2, train2));
err_ab_train = err_ab_train/n;

% EB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eb_norm1 = posterior_predict(ml_norm1);
eb_norm2 = posterior_predict(ml_norm2);
if 0
  draw(eb_norm1, 'r');
  draw(eb_norm2, 'r');
end

% compute the error rate on the training data
err_eb_train = sum(logProb(eb_norm1, train1) < logProb(eb_norm2, train1)) ...
    + sum(logProb(eb_norm1, train2) > logProb(eb_norm2, train2));
err_eb_train = err_eb_train/n;

% Fisher discriminant %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
a = inv(v)*(get_mean(norm2) - get_mean(norm1));
t = (get_mean(norm2)'*inv(v)*get_mean(norm2) - ...
    get_mean(norm1)'*inv(v)*get_mean(norm1))/2;
opt = logit_density([t; -a]);
if d == 2
  draw(opt, 'k');
end

% compute the error rate on the training data
data = [ones(1, cols(train1)) -ones(1, cols(train2)); train1 -train2];
err_opt_train = sum(exp(logProb(opt, data)) < 0.5)/n;
end

err_opt_train = sum(logProb(norm1, train1) < logProb(norm2, train1)) ...
    + sum(logProb(norm1, train2) > logProb(norm2, train2));
err_opt_train = err_opt_train/n;

%drawnow

% Test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n1 = 1e4;
n2 = 1e4;
n = n1 + n2;
test1 = sample(norm1, n1);
test2 = sample(norm2, n2);

% compute the error rate
err_ml_test = sum(logProb(ml_norm1, test1) < logProb(ml_norm2, test1)) ...
    + sum(logProb(ml_norm1, test2) > logProb(ml_norm2, test2));
err_ml_test = err_ml_test/n;

% compute the error rate
err_ub_test = sum(logProb(ub_norm1, test1) < logProb(ub_norm2, test1)) ...
    + sum(logProb(ub_norm1, test2) > logProb(ub_norm2, test2));
err_ub_test = err_ub_test/n;

% compute the error rate
err_ab_test = sum(logProb(ab_norm1, test1) < logProb(ab_norm2, test1)) ...
    + sum(logProb(ab_norm1, test2) > logProb(ab_norm2, test2));
err_ab_test = err_ab_test/n;

% compute the error rate
err_eb_test = sum(logProb(eb_norm1, test1) < logProb(eb_norm2, test1)) ...
    + sum(logProb(eb_norm1, test2) > logProb(eb_norm2, test2));
err_eb_test = err_eb_test/n;

% compute the error rate
err_opt_test = sum(logProb(norm1, test1) < logProb(norm2, test1)) ...
    + sum(logProb(norm1, test2) > logProb(norm2, test2));
err_opt_test = err_opt_test/n;

if 0
  % the minimum possible error rate
  m1 = a'*get_mean(norm1);
  c = a'*(get_mean(norm2) - get_mean(norm1));
  1/2*erfc((t - m1)/sqrt(2*c));
end
