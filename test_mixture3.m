% Example of finding the right number of components

norm1 = normal_density(3, 0.5);
norm2 = normal_density(6, 1);
if 1
  mix = mixture_density(ones(1, 2), norm1, norm2);
else
  norm3 = normal_density(5, 0.1);
  mix = mixture_density(ones(1, 3), norm1, norm2, norm3);
end

data = sample(mix, 1000);
figure(1);
%plot(data, 0.1*ones(1, length(data)), 'k.');
axis([0 10 0 0.35]);
draw(mix, 'g--');

js = [1 2 3 4 5 6 7];
%js = 7;
for i = 1:length(js)
  j = js(i);
  
  c = {};
  for k = 1:j
    c{k} = normal_density(rand*10, 1);
    %c{k} = set_cov_type(c{k}, 'fixed');
  end
  obj = mixture_density(ones(1, length(c)), c{:});
  %obj = set_temperature(obj, 0.1);
  obj = train(obj, data);

  p(i) = sum(logProb(obj, data));
  e(i) = evidence(obj, data);
  
  figure(4)
  plot(js(1:i), e(1:i));
  figure(5)
  plot(js(1:i), p(1:i));
  
  pause
end

% j = 3 is really 3
% j = 5 is really 4
% j = 6 is really 4
