function plot_posterior_e(obj, data, r)

e = obj.e;
for i = 1:length(r)
  obj.e = r(i);
  z(i) = exp(sum(logProb(obj, data)));
end
plot(r, z);

obj.e = e;
% plot the current parameters on top of the posterior
p = exp(sum(logProb(obj, data)));
hold on
plot(e, p, 'x');
hold off

