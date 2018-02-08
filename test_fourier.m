true = normal_density(0, 0.5);
true = uniform_density(-5, 5);
true = mixture_density([1 1], true, normal_density(5, 0.3));
true = mixture_density([1 1], true, normal_density(-5, 0.7));
data = sample(true, 101);

if 0
tic
kern = kernel_density;
kern = train(kern, data);
toc

tic; logProb(kern, data(1)); toc
else
  clear kern
end

tic
obj = fourier_density;
if 0
  figure(2)
  axis([-1 2 0 2]);
  plot(obj)
end
obj = train(obj, data);
toc

tic; logProb(obj, data(1)); toc

figure(1)
plot(data, 0.1*ones(size(data)), 'wo');
axis([-10 10 0 1]);
%axis([-5 5 0 1]);
%axis([-30 30 0 1]);
draw(obj, 'b');
if exist('kern')
  draw(kern, 'r');
end
draw(true, 'g--');
%set(gca, 'Color', [0 0 0])
axis tight

r = -30:0.1:30;
sum(exp(logProb(obj,r)))*0.1
