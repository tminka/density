if 0
  d = 3;
  v = eye(d);
  n = 5;
  train1 = gauss_sample([-1;0;0]*2, v, n);
  train2 = gauss_sample([1;0;0]*2, v, n);
  save task2.mat train1 train2
end

ts = 0:0.5:4;
e_true = [];
e_laplace = [];
for i = 1:length(ts)
  t = ts(i);
  if 0
    load task2.mat
    train1(1,:) = train1(1,:) + t;
    train2(1,:) = train2(1,:) - t;
  else
    data = 2*rand(d,10)-1;
    j = find(col_sum(data) >= 0);
    train1 = data(:,j);
    j = find(col_sum(data) < 0);
    train2 = data(:,j);
  end    

  % note that we do not augment the data, so the line must go through zero.
  data = [train1 -train2];

  obj = logit_density(ones(rows(data), 1)/10, 0);
  obj.prior_type = 'gaussian';
  obj.prior_icov = eye(rows(data))/1e4;
  obj.e_type = 'fixed';

  obj = train(obj, data);
  figure(1)
  plot(train1(1, :), train1(2, :), 'o', train2(1, :), train2(2, :), 'x');

  e_laplace(i) = evidence_theta(obj, data);
  e_true(i) = evidence_theta_exact(obj, data);
end

figure(3)
plot(ts, e_true, ts, e_laplace)

