% test train_counts

K = 2;
a = ones(K,1)*2;
a = [1 3];
obj = dirichlet_density(a);

N = 20;
if 0
  counts = [];
  for i = 1:N
    die = multinomial_density(sample(obj));
    x = sample(die, 100);
    h = hist_int(x, k);
    counts(:,i) = h(:);
  end
  if cols(counts) < 20
    counts
  end
elseif 0
counts =  [0, 4222, 0, 3885, 0, 2480, 0, 2474, 0, 1818, 0, 3964, 0, 1786, ...
      0, 2798, 0, 2526, 21, 3115, 0, 3923, 0, 4352, 0, 2508, 0, 4286, 0, ...
      3627, 0, 4260, 0, 4041, 0, 5876, 1, 5977, 0, 3807];
counts = reshape(counts, 2, length(counts)/2);
else
  counts = floor(rand(K, N)*100);
end

obj = train_counts(obj, counts);
disp(obj)

return
obj = dirichlet_density(ones(K,1)/K*1e6);
obj = train_mean_counts(obj, counts);
get_a(obj)/sum(get_a(obj))
