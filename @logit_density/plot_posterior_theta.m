function e = plot_posterior_theta(obj, data, r1, r2)

if length(obj.theta) == 1
  theta = obj.theta;
  z = [];
  for i = 1:length(r1)
    obj.theta = r1(i);
    z(i) = exp(sum(logProb(obj, data)) + prior_theta_logProb(obj, obj.theta));
  end
  plot(r1, z);
  
  % plot the current parameters on top of the posterior
  obj.theta = theta;
  p = exp(sum(logProb(obj, data)) + prior_theta_logProb(obj, theta));
  hold on
  plot(theta, p, 'x');
  hold off
  sum(z)
  return
end

if length(obj.theta) ~= 2
  error('Posterior is not two-dimensional');
end
if nargin < 4
  r2 = r1;
end

theta = obj.theta;
[x,y] = meshgrid(r1, r2);
z = [];
for i = 1:rows(x)
  for j = 1:cols(x)
    obj.theta(1) = x(i, j);
    obj.theta(2) = y(i, j);
    z(i, j) = sum(logProb(obj, data));
    z(i, j) = z(i,j) + prior_theta_logProb(obj, obj.theta);
  end
end
z = exp(z);
mesh(r1, r2, z);
view(0, 85);
rotate3d on;
colormap('hsv');
axis tight;

% plot the current parameters on top of the posterior
obj.theta = theta;
p = sum(logProb(obj, data));
p = p + prior_theta_logProb(obj, theta);
p = exp(p);
hold on
plot3(theta(1), theta(2), p, 'x');
hold off

e = sum(sum(z));
