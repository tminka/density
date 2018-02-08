function [err_ml_test, err_ab_test, err_eb_test, err_opt_test] ...
    = test_multinomial_bayes(d, n1, n2)
% [err_ml_test, err_ab_test, err_eb_test, err_opt_test] = test_multinomial_bayes(2,10,10)

n = n1+n2;

% p1 and p2 are sampled from D(1, ..., 1)
prior = dirichlet_density(ones(d,1)*5);
p1 = sample(prior);
p2 = sample(prior);
p1'
p2'

class1 = multinomial_density(p1);
class2 = multinomial_density(p2);

train1 = sample(class1, n1);
train2 = sample(class2, n2);

% ML %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ml_1 = train(multinomial_density(ones(d,1),prior), train1);
ml_2 = train(multinomial_density(ones(d,1),prior), train2);

disp(ml_1)
disp(ml_2)

% compute the error rate on the training data
err_ml_train = sum(logProb(ml_1, train1) <= logProb(ml_2, train1)) ...
    + sum(logProb(ml_1, train2) >= logProb(ml_2, train2));
err_ml_train = err_ml_train/n;

% AB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ab_1 = posterior_predict(ml_1);
ab_2 = posterior_predict(ml_2);

% compute the error rate on the training data
err_ab_train = sum(logProb(ab_1, train1) <= logProb(ab_2, train1)) ...
    + sum(logProb(ab_1, train2) >= logProb(ab_2, train2));
err_ab_train = err_ab_train/n;

% EB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eb_1 = ab_1;
eb_2 = ab_2;

% Test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

err_ml_test = 0;
err_ab_test = 0;
err_eb_test = 0;
err_opt_test = 0;

% 100 groups of n samples
n = 100;
for i = 1:100
  test1{i} = {sample(class1, n)};
  test2{i} = {sample(class2, n)};
end

if 0
err_ml_test = sum(logProb(ml_1, test1) <= logProb(ml_2, test1)) + ...
    sum(logProb(ml_1, test2) >= logProb(ml_2, test2));

err_ab_test = sum(logProb(ab_1, test1) <= logProb(ab_2, test1)) + ...
    sum(logProb(ab_1, test2) >= logProb(ab_2, test2));

err_opt_test = sum(logProb(class1, test1) <= logProb(class2, test1)) + ...
    sum(logProb(class1, test2) >= logProb(class2, test2));

for i = 1:length(test1)
  err_eb_test = err_eb_test + ...
      (evidence(eb_1, test1{i}) <= evidence(eb_2, test1{i})) + ...
      (evidence(eb_1, test2{i}) >= evidence(eb_2, test2{i}));
end

else
  
  data = cat(2, test1, test2);
err_ml_test = logProb(ml_1, data) - logProb(ml_2, data);
err_ab_test = logProb(ab_1, data) - logProb(ab_2, data);
err_opt_test = logProb(class1, data) - logProb(class2, data);

for i = 1:length(data)
  err_eb_test(i) = evidence(eb_1, data{i}) - evidence(eb_2, data{i});
end

end

if d == 2
  % Display the decision boundaries
  figure(2)
  for i = 1:n
    x = [ones(1,i) 2*ones(1,n-i)];
    c_ml(i) = sum(logProb(ml_1, x)) < sum(logProb(ml_2, x));
    c_ab(i) = sum(logProb(ab_1, x)) < sum(logProb(ab_2, x));
    c_eb(i) = evidence(eb_1, x) < evidence(eb_2, x);
    c_opt(i) = sum(logProb(class1, x)) < sum(logProb(class2, x));
  end
  plot(1:n, c_ml, 1:n, c_ab, 1:n, c_eb, 1:n, c_opt)
  axis([1 n -0.1 1.1])
  legend('ML', 'AB', 'EB', 'Opt',0)
end
