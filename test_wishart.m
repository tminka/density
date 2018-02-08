if 0
  a = 50;
  obj = wishart_density(inv(0.5/a), a);
  %obj = wishart_density(0.5*a, a+2, 'inverse');
  plot(obj)
  return
end

% one dimension %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
a = 5/2;
b = 14;
obj = wishart_density(2/b, 2*a);
plot(obj)
drawnow

if 1
  % check the normalizing constant
  inc = 1;
  data = 1:inc:200;
  p = cat(logProb(obj, num2cell(data)));
  p = p{:};
  % result should be 0
  logSum(p') + log(inc)
end

data = sample(obj, 2000);
a*b
mean(data)
a*b*b
var(data)

return
end

if 1
a = 4.5;
b = 1/113;
obj = wishart_density(2/b, 2*a, 'inverse');
plot(obj)
drawnow

if 1
  % check the normalizing constant
  inc = 1;
  data = 1:inc:200;
  p = cat(logProb(obj, num2cell(data)));
  p = p{:};
  % result should be 0
  logSum(p') + log(inc)
  %return
end

data = sample(obj, 2000);
1/b/(a-1)
mean(data)
1/b^2/(a-1)^2/(a-2)
var(data)

return
end

if 0
% other moments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c = 1/7;
n = 5;
obj = wishart_density(c, n, 'inverse');
data = sample(obj, 10000);
c/(n-2)
mean(data)
n/c
mean(1./data)
log(c) - digamma(n)
mean(log(data))

return
end

% two dimensions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = 2;
%a = 70;
a = 4;
%v = [4 1; 1 3];
v = eye(d);
if 1
  obj = wishart_density(pinv(v), a);
else
  obj = wishart_density(v, a, 'inverse');
end

if 0
  % test the normalizing constant (must be done on an alpha)
  s = 30;
  data = rand(4, 20000)*s;
  data(2, :) = data(2, :) - s/2;
  % force symmetry
  data(3, :) = data(2, :);
  data = map(num2cell(data,1), 'vtrans', 2);
  % reject those that aren't pos def
  %data = filter(data, 'isposdef');
  i = cat(det(data));
  i = find(i{1} > 0);
  f = length(i)/length(data);
  data = {data{i}};
  disp([num2str(length(data)) ' matrices kept'])
  p = cat(logProb(obj, data));
  p = p{:};
  % result should be 0
  % s^3*f is the volume of the sampling space
  logSum(p') - log(length(data)) + 3*log(s) + log(f)
  return
end

%logProb(obj, vec(v))

n = 1000;
data = sample(obj, n);

if get_inverse(obj)
  v/(a - d - 1)
else
  v*a
end
mean(data)

s = mean(logdet(data))
if get_inverse(obj)
  logdet(v/2) - digamma(a/2) - digamma(a/2-1/2)
else
  logdet(v*2) + digamma(a/2) + digamma(a/2-1/2)
end
return

% covariance test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = vec(v)*vec(v)';
% transpose every submatrix
for i = 1:d
  for j = 1:d
    c((d*(i-1)+1):(d*i), (d*(j-1)+1):(d*j)) = ...
	c((d*(i-1)+1):(d*i), (d*(j-1)+1):(d*j))';
  end
end
a*(kron(v, v) + c)
cov(data')

if n < 10
figure(1);
g = normal_density(zeros(2, 1), v);
plot(g, 'm');
for i = 1:cols(data)
  g = normal_density(zeros(2, 1), reshape(data(:, i), 2, 2));
  draw(g);
end
axis auto
end

obj = wishart_density(pinv(v), a, 'inverse');

n = 5000;
data = sample(obj, n);

k = inv(v);
k/(a-d-1)
reshape(mean(data'), d, d)
c = vec(k)*vec(k)';
% transpose every submatrix
for i = 1:d
  for j = 1:d
    c((d*(i-1)+1):(d*i), (d*(j-1)+1):(d*j)) = ...
	c((d*(i-1)+1):(d*i), (d*(j-1)+1):(d*j))';
  end
end
(kron(k, k) + c + 2*vec(k)*vec(k)'/(a-d-1))/(a-d)/(a-d-1)/(a-d-3)
cov(data')
