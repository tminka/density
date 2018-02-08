norm1 = normal_density(0, 1);
norm2 = normal_density(3, 1);
mix = mixture_density([0.5 0.5], norm1, norm2);

n = 10;
train1 = sample(norm1, n);
train2 = sample(norm2, n);
data = [train1 train2; ones(1, n) ones(1, n)*2];

% bound parameter
norm2 = normal_density(3, 1);
obj = set_component(mix, 2, norm2);
q = logSub(0, class_logProb(obj, data));
q2 = logSub(0, q);

% plot the likelihood
ms = -5:0.2:5;
for i = 1:length(ms)
  norm2 = normal_density(ms(i), 1);
  obj = set_component(mix, 2, norm2);
  
  p = class_logProb(obj, data);
  p2 = logSub(0, p);
  r = [logProb(norm1, train1)-logProb(norm2, train1) ...
	logProb(norm2, train2)-logProb(norm1, train2)];
  if 1
    like(i) = sum(p);
    b(i) = sum(exp(q) .* r);
    %b(i) = b(i) + sum(exp(p2) .* p2) + sum(exp(p) .* p);
    b(i) = b(i) + sum(exp(q) .* q) + sum(exp(q2) .* q2);
    %b(i) = b(i) + sum(exp(p) .* q) + sum(exp(p2) .* q2);
    %b(i) = b(i) + sum(exp(q) .* p) + sum(exp(q2) .* p2);
  else
    like(i) = exp(logSum(p'));
    b(i) = sum(exp(q + q2) .* r);
    b(i) = b(i) - sum(exp(q + q2) .* q2);
  end
end
plot(ms, like, ms, b);
%plot(1:(length(ms)-1), diff(like), 1:(length(ms)-1), diff(b))
