figure(1);
clf
axis([-4 4 0 0.5])

colors = ['r' 'g' 'b' 'c'];
as = [0.5 1 2 10];
for i = 1:length(as)
  obj = gen_exp_density(0, as(i), 2);
  disp(obj);
  draw(obj, colors(i));

  if 1
    p = logProb(obj, -50:0.01:50);
    sum(exp(p))*0.01
    
    -sum(p.*exp(p))*0.01
    entropy(obj)
  end

end

if 0
  data = rand(1,100);
else
  data = randn(1,100);
  data = data .^ 3;
  data = data + 0.5;
end

obj = train(obj, data);
disp(obj);
figure(2)
plot(data, (1:length(data))/length(data), '.');
axis([-2 2 0 2]);
draw(obj)
