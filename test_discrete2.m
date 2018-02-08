% test the entropy approximation to the evidence

k = 10;
prior = dirichlet_density(ones(1,k));
g = 20;
d = [];
for j = 1:10
  n = 10*j*j*j;
  for i = 1:g
    p = sample(prior, 1);
    obj = discrete_density(p);
    data = sample(obj, n);
    e(i) = evidence(obj, data);
    obj = train(obj, data);
    h(i) = -n*entropy(obj);
  end
  figure(1)
  plot(1:g, e, 1:g, h)
  d(j) = mean(e-h)
end
figure(2)
js = 1:10;
ns = 10*js.*js.*js;
plot(js, d, js, -log(ns)*4.1+3)
% k = 2, multiply by 1/2
% k = 3, multiply by 2/2
% k = 4, multiply by 1.4
% k = 5, multiply by 1.8
% k = 10, multiply by 4.1 and add 3
