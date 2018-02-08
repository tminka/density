% test forward and backward prediction

t = 0:0.01:1;
data = sin(t*20);
plot(data)

k = 1;
initial_density = normal_density(zeros(k,1), eye(k));
obj = ar_density(k, lls_density(0.7, 0.01), initial_density);

data = sample(obj, 200);
plot(data)

obj = train(obj, {data});
disp(obj);

data = fliplr(data);
obj = train(obj, {data});
disp(obj);
