norm1 = normal_density(3, 1);
norm1 = set_prior(norm1, normal_density(NaN, 1));
norm2 = normal_density(6, 1);
norm2 = set_prior(norm2, normal_density(NaN, 1));
mix = mixture_density([0.5 0.5], norm1, norm2);

%data = sample(mix, 100);
data = -3:0.01:12;

r1 = 0;
r2 = 10;
inc = (r2-r1)/20;
r = r1:inc:r2;
x = lattice([r1 inc r2; r1 inc r2]);
for i = 1:cols(x)
  norm1 = set_mean(norm1, x(1,i));
  norm2 = set_mean(norm2, x(2,i));
  obj = mixture_density(ones(1,2)/2, norm1, norm2);
  %z(i) = sum(logProb(obj, data));
  z(i) = prior_logProb(obj, data, 0.01);
end
z = reshape(z, length(r), length(r));
%z = exp(z);
figure(1);
mesh(r, r, z);
rotate3d on;
axis tight;
