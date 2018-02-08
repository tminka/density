function [mbr, likelihood] = classify(obj, x)
% mbr(i, j) is p(c_i | x_j), the responsibility of component i for x{j}.
% likelihood is the same as logProb(obj, x).

n = cols(x);
likelihood = -Inf*ones(1, n);
mbr = -Inf*ones(length(obj.weights), cols(x));
for i = 1:length(obj.weights)
  c = obj.components{i};
  if obj.weights(i) > 0
    mbr(i,:) = logProb(c, x)/obj.temperature + log(obj.weights(i));
  end
end
likelihood = logsumexp(mbr,1);
for i = 1:length(obj.weights)
  mbr(i,:) = exp(mbr(i,:) - likelihood);
end

if 0
  % hard assignment
  [v,j] = max(mbr);
  mbr = zeros(size(mbr));
  for i = 1:cols(mbr)
    mbr(j(i), i) = 1;
  end
end
