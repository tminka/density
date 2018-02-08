obj = multinomial_density([0.2 0.3 0.5], 10);
disp(obj)
figure(1)
plot(obj);

data = sample(obj, 100);
figure(2)
bar(row_sum(data))

sum(logProb(obj, data))

obj = train(obj, data);
disp(obj)

post = posterior_predict(obj);
disp(post)
disp(get_prior(post))
