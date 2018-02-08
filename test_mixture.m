norm1 = normal_density(3, 1);
norm1 = set_prior(norm1, normal_density(NaN, 1));
norm2 = normal_density(6, 1);
norm2 = set_prior(norm2, normal_density(NaN, 1));
mix = mixture_density([0.5 0.5], norm1, norm2);
%disp(mix);

% answer should be 0.2017
disp(['probability of 7 is ' num2str(exp(logProb(mix, 7)))]);

% answer should be [0.010987 0.98901]
disp(['membership is ' num2str(classify(mix, 7)')]);

data = sample(mix, 20);
%data = [6.9950    7.4855    6.7238    4.0559    2.8929    8.2765];
figure(1);
%plot(data, 1:length(data), 'o');
plot(data, 0.1*ones(1, length(data)), 'ko');
%bar(sort(data), 0.1*ones(1, length(data)), 0.1)
%draw(mix);
axis([0 10 0 0.35]);

figure(1)
draw(mix, 'g--');

%mix = set_temperature(mix, 0.1);
if 0
  obj = train(mix, data);
  disp(obj);
end

if 1
  inc = 0.01;
  data = (3-4*3):inc:(6+4*3);
  prior_logProb(mix, data, inc)
end

if 0
post = posterior_predict(obj, data);
figure(1);
draw(post, 'g--');
% print -dps2 mix_predict4.ps

% compute the divergence with the true distribution (smaller is better)
r = 1:0.1:11;
ptrue = logProb(mix, r);
p1 = logProb(obj, r);
p2 = logProb(post, r);

sum(exp(ptrue) .* (ptrue - p1))
sum(exp(ptrue) .* (ptrue - p2))
end
