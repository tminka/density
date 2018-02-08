function e = plot_posterior(obj, data, r1, r2)

if 0 & length(obj.data)
  w = obj.w;
  z = [];
  for i = 1:length(r)
    obj.w = r(i);
    z(i) = exp(sum(logProb(obj, data)) + logProb(obj.prior, obj.w));
  end
  plot(r, z);
  
  % plot the current parameters on top of the posterior
  obj.w = w;
  p = exp(sum(logProb(obj, data)) + logProb(obj.prior, w));
  hold on
  plot(w, p, 'x');
  hold off
  sum(z)
  return
end

if length(obj.w) ~= 2
  error('Posterior is not two-dimensional');
end

w = obj.w;
[x,y] = meshgrid(r1, r2);
z = [];
for i = 1:rows(x)
  for j = 1:cols(x)
    obj.w(1) = x(i, j);
    obj.w(2) = y(i, j);
    z(i, j) = sum(logProb(obj, data));
    z(i, j) = z(i,j) + logProb(obj.prior, obj.w);
  end
end
z = exp(z);
mesh(r1, r2, z);
view(0, 85);
rotate3d on;
colormap('hsv');
axis tight;

% plot the current parameters on top of the posterior
obj.w = w;
p = sum(logProb(obj, data));
p = p + logProb(obj.prior, w);
p = exp(p);
hold on
plot3(w(1), w(2), p, 'x');
hold off

e = sum(sum(z));
