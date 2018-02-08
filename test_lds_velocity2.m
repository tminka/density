A = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];
Gamma = directsum(zeros(2), eye(2)/10);
C = eye(4);
Sigma = eye(4)/10000;
m1 = [0;0;1;1];
v1 = Gamma;
lds = lds_density(A, Gamma, m1, v1, C, Sigma);
disp(lds);

n = 20;
data = sample(lds, n);
figure(1)
plot(data(1, :), data(2, :), 'o');
figure(10)
plot(data(3, :), data(4, :), 'o');
logProb(lds, {data})

if 0
% for comparison, sample from the equivalent Gaussian distribution
gauss = asGaussian(lds, n);
x = sample(gauss);
x = vtrans(x, rows(A));
figure(2);
plot(x(1, :), x(2, :), 'o');
end

% hide part of the state
data = data(1:2, :);

if 1
C = [1 0 0 0; 0 1 0 0];
Sigma = eye(2)/10;
obj = lds_density(A, Gamma, m1, v1, C, Sigma);

disp(train(obj, {data}));
end
