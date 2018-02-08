A = [1 1; 0 1];
Gamma = [0 0; 0 1]/10;
C = eye(2);
Sigma = eye(2)/2;
m1 = [0;1];
v1 = Gamma;
lds = lds_density(A, Gamma, m1, v1, C, Sigma);
disp(lds);

n = 20;
[data, states] = sample(lds, n);
figure(1)
%subplot(2,1,1);
plot(1:n, data(1, :), '-o', 1:n, states(1, :), '--');
xlabel('time');
ylabel('position');
title('Measurement sequence');
%subplot(2,1,2);
%plot(1:n, data(2, :), 1:n, states(2, :), '--');
%xlabel('time');
%ylabel('velocity');
% orient landscape
% print -dpsc2 lds_measurement.ps

if 1
  % hide part of the state
  data = data(1, :);

  C = [1 0];
  Sigma = Sigma(1);
  lds = lds_density(A, Gamma, m1, v1, C, Sigma);
end

[p, means] = logProb(lds, {data});
figure(3)
subplot(2,1,1);
plot(1:n, means(1, :), 1:n, states(1, :), '--');
xlabel('time');
ylabel('position');
title('Forward estimates');
subplot(2,1,2);
plot(1:n, means(2, :), 1:n, states(2, :), '--');
xlabel('time');
ylabel('velocity');
% print -dpsc2 lds_forward.ps

[means, vars, covs, likelihood] = classify(lds, data);
figure(2)
subplot(2,1,1);
plot(1:n, means(1, :), 1:n, states(1, :), '--');
xlabel('time');
ylabel('position');
title('Smoothed estimates');
subplot(2,1,2);
plot(1:n, means(2, :), 1:n, states(2, :), '--');
xlabel('time');
ylabel('velocity');
% print -dpsc2 lds_smoothed.ps

figure(4)
subplot(2,1,1)
plot(1:n, vars(1, :));
xlabel('time');
ylabel('position variance');
title('Estimate variances');
subplot(2,1,2)
plot(1:n, vars(4, :));
xlabel('time');
ylabel('velocity variance');
% print -dpsc2 lds_variance.ps

if 0
% for comparison, sample from the equivalent Gaussian distribution
gauss = asGaussian(lds, n);
x = sample(gauss);
x = vtrans(x, rows(A));
figure(2);
plot(x(1, :), x(2, :), 'o');
end

% hide part of the state
data = data(1, :);

if 0
C = [1 0; 0 0];
Sigma = eye(1)/10;
obj = lds_density(A, Gamma, m1, v1, C, Sigma);

disp(train(obj, {data}));
end
