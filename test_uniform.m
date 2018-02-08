obj = uniform_density(2, 5);
disp(obj);

data = sample(obj, 100);
figure(1);
plot(data, ones(1, cols(data))/3, '.');
draw(obj);

obj = uniform_density([2; 3], [5; 6]);
data = sample(obj, 100);
figure(2);
plot(data(1, :), data(2, :), '.');
draw(obj);

obj = uniform_density(0.7);
disp(obj);
logProb(obj, 1)
