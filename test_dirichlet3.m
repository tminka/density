% test train_mean_counts

do_mean = 0;

% draw a random count matrix
N = 10;
K = 3;
data = floor(rand(K, N)*100);

s = 1;
m = ones(K,1)/K;

weight = ones(1, N);
weight(3) = 0;

if 0
  % this doesn't work as an initializer
  bar_p = moment1(counts+1);
  bar_p = bar_p/sum(bar_p);
  s = (K-1)/2/(sum(m.*log(m./bar_p)))
end

obj = dirichlet_density(s*m);
if do_mean
  obj = train_mean_counts(obj, data);
else
  obj = train_var_counts(obj, data);
end
disp(obj)

obj = dirichlet_density(s*m);
if do_mean
  obj = train_mean_counts(obj, data, weight);
else
  obj = train_var_counts(obj, data, weight);
end
disp(obj)

% check
data2 = data;
data2(:,3) = [];
obj = dirichlet_density(s*m);
if do_mean
  obj = train_mean_counts(obj, data2);
else
  obj = train_var_counts(obj, data2);
end
disp(obj)

m = m';
data = data';
weight = weight';

obj = dirichlet_density(s*m);
if do_mean
  obj = train_mean_counts(obj, data);
else
  obj = train_var_counts(obj, data);
end
disp(obj)

obj = dirichlet_density(s*m);
if do_mean
  obj = train_mean_counts(obj, data, weight);
else
  obj = train_var_counts(obj, data, weight);
end
disp(obj)

return

counts =  [0, 4222, 0, 3885, 0, 2480, 0, 2474, 0, 1818, 0, 3964, 0, 1786, ...
      0, 2798, 0, 2526, 21, 3115, 0, 3923, 0, 4352, 0, 2508, 0, 4286, 0, ...
      3627, 0, 4260, 0, 4041, 0, 5876, 1, 5977, 0, 3807];
counts = reshape(counts, 2, length(counts)/2);
[K,N] = size(counts);

% unscaled
p1 = row_sum(counts);
p1 = p1/sum(p1);

% scaled
p2 = counts ./ repmat(col_sum(counts), K, 1);
p2 = row_sum(p2);
p2 = p2/sum(p2);

% loop alphas
alphas = exp(8:10);
e1 = [];
e2 = [];
for i = 1:length(alphas)
  obj = dirichlet_density(ones(K,1)*alphas(i)/K);
  obj = train_mean_counts(obj, counts);
  m = get_a(obj) / sum(get_a(obj));
  e1(i) = sum(p1 .* log(p1 ./ m));  
  e2(i) = sum(p2 .* log(p2 ./ m));
end
figure(1)
plot(log(alphas), e1, log(alphas), e2);
plot(log(alphas), e1)

return
obj = dirichlet_density(ones(K,1));
obj = train_counts(obj, counts);

% 6 iters to get 1.2323
