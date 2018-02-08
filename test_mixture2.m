norm1 = normal_density([3;4], [1 1;1 2]);
norm2 = normal_density([2;3], [2 1;1 1]);
mix = mixture_density([0.5 0.5], norm1, norm2);
disp(mix);

data = sample(mix, 80);
figure(1);
plot(data(1, :), data(2, :), '.');
draw(mix);

norm1 = normal_density(randn(2, 1), eye(2));
norm1 = set_prior(norm1, normal_density(NaN, 1));
norm2 = normal_density(randn(2, 1), eye(2));
norm2 = set_prior(norm2, normal_density(NaN, 1));
%norm1 = set_cov_type(norm1, 'spherical');
%norm2 = set_cov_type(norm2, 'spherical');
%norm1 = set_cov_type(norm1, 'diagonal');
%norm2 = set_cov_type(norm2, 'diagonal');
obj = mixture_density([0.5 0.5], norm1, norm2);
obj = train(obj, data);
disp(obj);
figure(1);
draw(obj, 'r');

if 0
  %mix2 = sample_posterior(mix);
  %draw(mix2, 'k');

  post = posterior_predict(obj, data);
  figure(2);
  plot(data(1, :), data(2, :), '.');
  density_image(post);
  
  % compute the divergence with the true distribution (smaller is better)
  x = lattice([0 0.1 6; 0 0.1 6]);
  ptrue = logProb(mix, x);
  p1 = logProb(obj, x);
  p2 = logProb(post, x);

  sum(exp(ptrue) .* (ptrue - p1))
  sum(exp(ptrue) .* (ptrue - p2))
end

if 0
  % compare m1-m2 to the principal axis of the data
  c = get_components(obj);
  m1 = get_mean(c{1});
  m2 = get_mean(c{2});
  v = m1-m2;
  v/norm(v)
  
  c = cov_t(data);
  [v,e] = sorted_eig(c);
  v(:,1)
end
