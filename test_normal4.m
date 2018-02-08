data = randn(1,100);

obj = normal_density(0,1);
obj = train(obj, data);
post = get_posterior(obj);
post_v = v_marginal(post);

vs = sample(post_v, 100);
vs = cat(2,vs{:});
plot(vs, ones(1, length(vs)), '.');
draw(post_v);
