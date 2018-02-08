% autoregressive modeling

r = 0:0.01:1;

x = [];
x(1) = 0.5;
x(2) = 0.3;

for i = 3:200
  %x(i) = 2 * x(i-1) * (1 - x(i-1)) + randn/10;
  x(i) = 1.9 * x(i-1) - 0.97 * x(i-2) + randn/10;
  %x(i) = 0.7 * x(i-1) + randn/10;
  x(i) = sin(i/10);
end

figure(1)
clf
plot(x);

k = 2;
obj = lls_density(ones(1, k), 1);
data = x(1:(length(x) - k));
for i = 1:k
  data = [data; x((i+1):(length(x)-k+i))];
end
obj = train(obj, data)

% simulate the model starting from halfway point
n = length(x)/2;
y = [];
y(1) = x(n-1);
y(2) = x(n);
for i = 3:100
  h = [];
  for j = 1:k
    h = [y(i-j); h];
  end
  y(i) = output_density(obj, h);
end
hold on
plot(n:(n+length(y)-1), y, 'g--');
