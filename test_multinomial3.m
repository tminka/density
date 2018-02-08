% use cross-validation for optimal smoothing

d = 2;
prior = dirichlet_density(ones(d,1));
p = sample(prior);
counts = sample_hist(p, 10);

u = 1/d;
lambda = cv_multinomial(counts, u);
cv_est = counts/sum(counts)*lambda + (1-lambda)*u;
