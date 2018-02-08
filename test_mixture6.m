% test the relationship between the means

norm1 = normal_density(3, 1/2);
norm1 = set_prior(norm1, normal_density(NaN, 1));
norm2 = normal_density(6, 1/2);
norm2 = set_prior(norm2, normal_density(NaN, 1));
mix = mixture_density([0.5 0.5], norm1, norm2);

%data = sample(mix, 200);
figure(1)
nhist(data,30)
drawnow

mix = train(mix, data);
get_mean(mix)
mean(data)

ms = 0:0.25:4.5;
m2s = ms+2;
m1 = [];
m2 = [];
for i = 1:length(ms)
  mix = set_component(mix, 1, set_mean(norm1, ms(i)));
  e = [];
  for j = 1:length(m2s)
    mix = set_component(mix, 2, set_mean(norm2, m2s(j)));
    e(j) = sum(logProb(mix, data));
  end
  [v,j] = max(e);
  m2(i) = m2s(j);
end
plot(ms, ms, ms, m2)

%figure(1)
%draw(mix)
