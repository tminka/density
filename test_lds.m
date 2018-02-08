theta = pi/6;
A = [cos(theta) sin(theta); -sin(theta) cos(theta)];
Gamma = eye(2)/10000;
C = eye(2);
Sigma = Gamma;
m1 = [0;1];
v1 = eye(2);
offset = ones(2, 1);
offset = zeros(2, 1);
input = ones(2, 1);
input = zeros(2, 1);
lds = lds_density(A, Gamma, m1, v1, C, Sigma, offset, input);
disp(lds);

if 1
n = 12;
data = sample(lds, n);
figure(1)
plot(data(1, :), data(2, :), 'o');
logProb(lds, {data})
end

if 1
% for comparison, sample from the equivalent Gaussian distribution
gauss = asGaussian(lds, n);
logProb(gauss, vec(data))
x = sample(gauss);
x = vtrans(x, 2);
figure(2);
plot(x(1, :), x(2, :), 'o');
end

if 0
lds = normalize(lds);
data = sample(lds, n);
figure(2)
plot(data(1, :), data(2, :), 'o');
end

%data = data + repeatcol(ones(2, 1)*10, cols(data));

if 0
A = randn(2);
% must start with large variances to get good convergence
Gamma = eye(2);
v1 = Gamma;
% but Sigma should be smaller so the right transitions get learned
Sigma = Gamma/10;
lds = lds_density(A, Gamma, m1, v1, C, Sigma, offset, input);

lds = train(lds, {data});
disp(lds);
end
