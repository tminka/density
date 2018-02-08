% one-dimensional case
% theta only controls the sharpness of the boundary

% path(path, '/u/tpminka/matlab/density')

n = 2;

if 0
  v = 1;
  train1 = randnorm(n, -1/2, [], v);
  train2 = randnorm(n, 1/2, [], v);
  %train2 = [];
  inc = 0.1;
  r = -10:inc:10;
end

if length(train2) > 0
  figure(1)
  plot(train1, zeros(1, n), 'o', train2, zeros(1, n), 'x');
else
  figure(1)
  plot(train1, zeros(1, n), 'o');
end

data = [train1 -train2];

obj = probit_density(1/10);
obj = train(obj, data);

% number of errors
sum(exp(logProb(obj, data)) <= 0.5)

% sum(logProb(obj, data))
