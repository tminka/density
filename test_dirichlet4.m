% plot the distribution of the log-ratios from a Dirichlet

obj = dirichlet_density([1; 1; 1]);

data = sample(obj, 10000);

m = col_sum(log(data))/rows(data);
m = log(data(rows(data),:));
x = log(data(1,:)) - m;
if rows(data) > 1
  y = log(data(2,:)) - m;
  if rows(data) > 2
    z = log(data(3,:)) - m;
  end
end
figure(2)
clf
if rows(data) == 2
  nhist(x,30);
  
  g = train(normal_density(0,1),x);
  hold on
  plot(g);
  hold off

  z = -6:0.1:6;
  pz = z - 2*log(exp(z)+1);
  hold on
  plot(z, exp(pz), 'r');
  hold off
elseif rows(data) == 3
  plot(x, y, '.')
  
  if 0
    inc = 0.5;
    z = -10:inc:10;
    zs = lattice([-10 inc 10; -10 inc 10]);
    pz = zs(1,:) + zs(2,:) - 3*log(exp(zs(1,:)) + exp(zs(2,:)) + 1);
    pz = reshape(pz, length(z), length(z));
    mesh(z, z, exp(pz))
    rotate3d on
  end
elseif rows(data) == 4
  plot3(x,y,z,'.')
end

