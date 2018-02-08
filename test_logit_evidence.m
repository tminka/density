if 0
  v = eye(2);
  n = 10;
  train1 = gauss_sample([-1;0]*2, v, n);
  train2 = gauss_sample([1;0]*2, v, n);
  save task1.mat train1 train2
end

ts = 0:0.5:4;
%ts = 3;
e_true = [];
e_laplace = [];
for i = 1:length(ts)
  t = ts(i);
  if 0
    load task1.mat
    train1(1,:) = train1(1,:) + t;
    train2(1,:) = train2(1,:) - t;
  else
    data = 2*rand(2,10)-1;
    j = find(col_sum(data) >= 0);
    train1 = data(:,j);
    j = find(col_sum(data) < 0);
    train2 = data(:,j);
  end

  % note that we do not augment the data, so the line must go through zero.
  data = [train1 -train2];

  obj = logit_density(ones(rows(data), 1)/10, 0);
  obj.prior_type = 'gaussian';
  obj.prior_icov = eye(2)/10000;
  obj.e_type = 'fixed';
  
  obj = train(obj, data);
  figure(1)
  plot(train1(1, :), train1(2, :), 'o', train2(1, :), train2(2, :), 'x');
  draw(obj,'g')

  e_laplace(i) = evidence_theta(obj, data);

  if 1
    % plot the posterior over theta
    v = obj.theta;
    h = max(abs(v));
    r1 = v - 4*h;
    r2 = v + 4*h;
    inc = (r2-r1)/50;
    rx = r1(1):inc(1):r2(1);
    ry = r1(2):inc(2):r2(2);
    
    figure(2);
    e_true(i) = log(plot_posterior_theta(obj, data, rx, ry)*prod(inc));
    if 0
      figure(5);
      post = get_posterior_theta(obj);
      plot(post, 'mesh', r);
    end
  else
    e_true(i) = evidence_theta_exact(obj, data);
  end
  
  if 0
    % plot the posterior over angle
    figure(2)
    plot_posterior_angle(obj, data);
    hold on
    % omit the misclassified sample
    data2 = data;
    data2(:,12) = [];
    plot_margin_angle(obj,data2);
    hold off
    v = axis;
    axis([-3 3 v(3) v(4)])
  end

end

figure(3)
plot(ts, e_true, ts, e_laplace)

