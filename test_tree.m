N = 1000;
if 0
  a = [10 10; 1 2; 3 4];
  a = [1 2; 3 4; 5 6];
  n1 = dirichlet_density(a(1,:));
  n2 = dirichlet_density(a(2,:));
  n3 = dirichlet_density(a(3,:));
  
  b1 = sample(n1, N);
  b2 = sample(n2, N);
  b3 = sample(n3, N);
  p = [repmat(b1(1,:),2,1) .* b2 ; repmat(b1(2,:),2,1) .* b3];
else
  n1 = dirichlet_density([1 20]);
  n2 = dirichlet_density([3 4 5]);
  b1 = sample(n1, N);
  b2 = sample(n2, N);
  p = [repmat(b1(1,:),3,1) .* b2 ; b1(2,:)];
end

lp = log(p);
J = rows(p);
v = zeros(J);
for j = 1:J
  for k = 1:J
    v(j,k) = var(lp(j,:) - lp(k,:));
  end
end
v

cluster_leaves(p)
