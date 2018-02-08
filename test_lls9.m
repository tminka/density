z = 0:0.01:1;
t = 0:1/10:1;
hs = (1:20)*1e-5;
e = [];
for i = 1:length(hs)
  x = gaussian_embedding(z, t, hs(i));
  %break
  [u,s,v] = svd(x',0);
  %e(i) = trace(pinv(x)*x);
  e(i) = trace(u*u');
end
figure(1)
plot(hs, e)
