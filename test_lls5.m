% predictive density test

obj = lls_density(2, 0.5);

n = 4;
x = randn(1, n);
y = sample(obj, x);
figure(1);
plot(x, y, 'o');
draw(obj);

obj = set_offset_type(obj, 'fixed');
obj = set_cov_type(obj, 'fixed');
data = [x; y];
obj = train(obj, data);
disp(obj);

post = prediction_posterior(obj);
figure(2);
clf
axis([1 3 0 1]);
draw(post);
axis tight;

figure(3);
clf
plot(x, y, 'o');
%axis([-1 1 -2 2]);
axis([-5 5 -10 10]);
%axis([-10 10 -20 20]);
%axis([-100 100 -200 200]);
hold on
plot_posterior_predict(obj);
hold off
xlabel('x')
ylabel('y')
