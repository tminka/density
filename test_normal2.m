obj = normal_density(2);
obj.mean = [3; 2];
obj.cov = [1 1; 1 2];

% answer should be 0.1592
exp(logProb(obj, [3; 2]))

data = sample(obj, 1000);
figure(1);
plot(data(1, :), data(2, :), '.');
draw(obj);

obj = train(obj, data)

%obj = train(obj, {[2; 4]})

% these numbers should be approximately equal
sum(logProb(obj, data))/cols(data)
logProb(obj, [3;2], vec([1 1; 1 2]))

c = eye(2)/2;
obj = train(obj, [2 4; 4 6], ones(1, 2)*1000, [vec(c) vec(c)])

obj.cov_type = 'spherical';
obj = train(obj, data)

if 0
  obj = set_cov_type(obj, 'reduced', 1, 0.1);
  obj = train(obj, data)
  draw(obj, 'r');
end
