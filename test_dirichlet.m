obj = dirichlet_density([3; 1; 2]);
disp(obj)
if 0
  figure(1)
  plot(obj)
  drawnow
end

%data = sample(obj, 10);
%figure(2);
%hist(data(1,:));

tic
trained = train(obj, data);
%trained = train_mean(obj, data);
%trained = train_var(obj, data);
toc
disp(trained)
return

trained_a = get_a(trained);
norm(trained_a - a)

if 0
slr = 0.7504;
x = 0:0.01:3;
figure(1)
plot(x, inv_digamma(digamma(x)-slr*2))
end
