obj = discrete_density([0.2 0.3 0.5]);
disp(obj)
figure(1)
plot(obj);

data = sample(obj, 1000);
figure(2)
hist(data)

sum(logProb(obj, data))

obj = train(obj, data);
disp(obj)

post = posterior_predict(obj);
disp(post)
disp(get_prior(post))
