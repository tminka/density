function p = logProb_bound(obj, x, mbr)

p = zeros(1, cols(x));
for i = 1:length(obj.weights)
  c = obj.components{i};
  cp = logProb(c, x) + log(obj.weights(i)+eps);
  p = p + (mbr(i,:) .* cp) - (mbr(i,:) .* log(mbr(i,:) + eps));
end
