function p = logProb(obj, x)
% numerical integration over w

% Monte Carlo sampling (awful)
%ws = sample(obj.weight_density, 1000);

% importance sampling
inc = 0.05;
d = length(get_a(obj.weight_density));
error('need to fix this')
ws = ndgridmat(repmat([inc inc 1], d-1, 1));
ws = [ws; 1-col_sum(ws)];
i = find(ws(d,:) > 0);
ws = ws(:,i);

p = -Inf*ones(1,cols(x));
for i = 1:cols(ws)
  w = ws(:,i);
  c = get_component(obj, w);
  % add logProb(w) for importance sampling
  q = logProb(c,x) + logProb(obj.weight_density, w);
  p = logSum(p, q);
end
p = p + (d-1)*log(inc);
