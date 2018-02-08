function p = logProb(obj, x)

p = -Inf*ones(1, cols(x));
for i = 1:length(obj.weights)
  if obj.weights(i) > 0
    c = obj.components{i};
    cp = logProb(c, x) + log(obj.weights(i));
    p = logsumexp([p; cp]);
  end
end
