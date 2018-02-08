function x = sample(obj, n)
% n is the number of blocks desired, all of size obj.block_size

if 1 | length(obj.p) >= n
  for i = 1:n
    x(:,i) = sample_hist(obj.p, obj.block_size);
  end
else
  % do all samples at once
  h = sample_hist(obj.p, obj.block_size*n);
  % then distribute them among the blocks
  for k = 1:length(obj.p)
    x(k,:) = sample_hist(ones(1,n)/n, h(k))';
  end
end
