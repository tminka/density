m = 0;
v = 1;
n = 5;
obj = t_density(m, v*n, n);
disp(obj);

figure(4);
normal = normal_density(m, v/n);
r = -4:0.1:4;
p = exp(logProb(obj, r));
plot(r, exp(logProb(normal, r)), r, p)

sum(r .* p)/sum(p)
sum(r .* r .* p)/sum(p)

data = sample(obj, 10000);
figure(1);
plot(data, 1:length(data), '.');
draw(obj);
draw(normal, 'b');

mean(data)
var(data)
v*n/(n-3)

m = zeros(2, 1);
v = [2 1; 1 2];
n = 5;
obj = t_density(m, v*n, n);
data = sample(obj, 20000);
figure(2);
plot(data(1, :), data(2, :), '.');

mean(data')
cov(data')
v*n/(n-4)

d = 5;
m = zeros(d, 1);
v = eye(d);
n = 8;
obj = t_density(m, v*n, n);
data = sample(obj, 50000);

mean(data')
cov(data')
v*n/(n-d-2)
