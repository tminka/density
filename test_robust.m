% robust estimation of Gaussian parameters

n = 200;
data = randn(1, n);
disp('True')
mean(data)
var(data)
data = [data 4 5];

figure(1)
plot(data, 1:length(data), '.');

% nonrobust estimates
disp('ML')
m = mean(data)
v = var(data)

% robust mean
for i = 1:10
  p = mvnormpdf(data, m, [], v);
  m = (data * p')/sum(p);
end
disp('Sum')
m
v = (data * diag(p) * data')/sum(p)
% variance tends to be too small

% corrected variance estimate
for i = 1:10
  p = mvnormpdf(data, m, [], v);
  m = (data * p')/sum(p);
  v = (data * diag(p) * data')/(sum(p) - 1/log(length(p)));
end
disp('Sum corrected')
m
v

if 0
% KL estimator
e = [];
h = [];
for i = 1:30
  p = mvnormpdf(data, m, [], v);
  q = p .* (1 + log(p * length(data)));
  m = (data * q')/sum(q);
  v = (data * diag(q) * data')/sum(q);
  e(i) = sum(p .* log(p * length(data)));
end
figure(2)
plot(e)
disp('KL')
m
v
else

  r = -10:0.001:10;
  if 1
    % we put a tiny Gaussian on each data point
    q = -Inf*ones(1, length(r));
    for i = 1:length(data)
      q = logSum(q, mvnormpdfln(r, data(:, i), [], 0.0001));
    end
  else
    q = mvnormpdfln(r, 0, 1);
  end
  figure(3);
  plot(r, q);
  drawnow
  
  ms = -5:0.5:5;
  vs = 0.01:0.25:5;
  ce = [];
  for mi = 1:length(ms)
    for vi = 1:length(vs)
      p = mvnormpdfln(r, ms(mi), [], vs(vi));
      ce(mi, vi) = sum(exp(p) .* (p - q));
    end
  end
  figure(2)
  mesh(vs, ms, ce);
  rotate3d on
  [x,mi] = min(ce);
  [x,vi] = min(x);
  ms(mi(vi))
  vs(vi)
end
