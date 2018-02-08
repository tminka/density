v = 0.5;
obj = lls_density(2, v, 1)

% answer should be 0.5642
exp(logProb(obj, [1; 2]));

% answer should be 
% y = [3 5]
% v = [0.5 4.5]
%[y, v] = output_density(obj, [1 2], [0 1]);

n = 2;
x = rand(1, n);
y = sample(obj, x);
figure(1);
clf
plot(x, y, '.');
draw(obj);

obj = set_offset_type(obj, 'fixed');
%obj = set_cov_type(obj, 'fixed');
%obj = set_prior(obj, normal_wishart_density(0, 0, 0.5*1000, 1000+2));

data = [x; y];
obj = train(obj, data)
%return

post = prediction_posterior(obj, get_cov(obj))
%post = prediction_posterior(obj);
figure(2);
clf
axis([1 3 0 1]);
draw(post);
axis tight;

if 0
  % plot evidence as a function of alpha
  alphas = (1:0.1:10)*1e-3;
  prior = get_prior(obj);
  n0 = 1;
  prior = set_n(prior, n0);
  prior = set_s(prior, n0);
  sxx = x*x';
  e = [];
  for i = 1:length(alphas)
    prior = set_k(prior, sxx*alphas(i));
    obj = set_prior(obj, prior);
    obj = train(obj, data);
    e(i) = evidence(obj);
  end
  figure(3)
  plot(alphas, e)
  [emax,i] = max(e);
  disp(['best alpha = ' num2str(alphas(i))])
end

if 0
  % plot evidence as a function of n0
  ns = (1:0.1:10)*v;
  prior = get_prior(obj);
  e = [];
  for i = 1:length(ns)
    prior = set_n(prior, ns(i));
    prior = set_s(prior, ns(i));
    obj = set_prior(obj, prior);
    obj = train(obj, data);
    e(i) = evidence(obj);
  end
  figure(3)
  plot(ns, e)
  [emax,i] = max(e);
  disp(['best n0 = ' num2str(ns(i))])
end

if 0
  data = [ones(1, length(data)); data];
  obj = lls_density(zeros(1, 2), 1);
  obj = set_offset_type(obj, 'fixed');
  obj = train(obj, data);
  disp(obj);
  
  post = prediction_posterior(obj);
  disp(post);
  figure(3);
  clf
  axis([0 2 0 2]);
  draw(post);
  axis tight;
end
