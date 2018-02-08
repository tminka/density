function p = logProb_bound2(obj, x, q, w0)

p = -Inf*ones(1, cols(x));
p0 = zeros(1, cols(x));
for i = 1:length(obj.weights)
  c = obj.components{i};
  lw = log(obj.weights(i)+eps);
  lw0 = log(w0(i,:));
  cp = logProb(c, x) + lw0;
  p = logSum(p, cp);
  p0 = p0 + (q(i,:) .* (lw - lw0));
end
p = p + p0;
