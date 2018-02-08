function obj = train_e(obj)

r = 0:0.01:1;
for i = 1:length(r)
  obj.e = r(i);
  z(i) = sum(logProb(obj, obj.data));
  % this may not be correct, since the normalizer for the prior is unknown
  z(i) = z(i) + prior_theta_logProb(obj, obj.theta);
end
figure(4)
plot(r, exp(z));
drawnow

[p,i] = max(z);
obj.e = r(i);
