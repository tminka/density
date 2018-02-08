function p = logProb(obj, x)

p = -Inf*ones(1, cols(x));
p(find(x == obj.mean)) = 0;
