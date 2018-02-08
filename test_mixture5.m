class{1} = multinomial_density([0.2 0.3 0.5]);
class{2} = multinomial_density([0.7 0.1 0.2]);
mix = mixture_density([0.5 0.5], class{:});
figure(1)
plot(mix);

data = cell(1, 100);
for i = 1:length(data)
  c = (rand > 0.5) + 1;
  data{i} = sample(class{c}, 10);
end
logProb(mix, data);

figure(1)
clf
hold off
p = rand(1,3);
class1 = multinomial_density(p/sum(p));
p = rand(1,3);
class2 = multinomial_density(p/sum(p));
obj = mixture_density([0.5 0.5], class1, class2);
obj = train(obj, data);
disp(obj)
