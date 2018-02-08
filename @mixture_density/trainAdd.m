function [obj, logp] = trainAdd(obj, x, weight)
% logp is the same as sum(logProb(obj, x))
% x is a matrix of columns or cell array.
% weight is a row vector.

n = cols(x);
if 0  % reweight
  if nargin < 3
    weight = ones(n, 1);
  end
  logp = 0;
  for i = 1:cols(x)
    [obj, like] = trainAddOne(obj, x(:, i), weight(i));
    logp = logp + like;
  end
  return
end

[mbr, logp] = classify(obj, x);
if nargout > 1
  if nargin > 2
    logp = logp*weight';
  else
    logp = sum(logp);
  end
end
if nargin > 2
  mbr = mbr .* repmat(weight, length(obj.weights), 1);
  obj.n = obj.n + sum(weight);
else
  % weight is implicitly a vector of ones.
  obj.n = obj.n + n;
end
obj.temp_weights = obj.temp_weights + mbr*ones(n, 1);

if obj.train_components
  % Train each component with the datum, weighted by its responsibility.
  for i = 1:length(obj.weights)
    c = obj.components{i};
    theta = [get_mean(c); vec(get_cov(c))];
    logp = logp + logProb(get_prior(c),theta);
    obj.components{i} = trainAdd(c, x, mbr(i, :));
  end
end

if 0
  % display the match matrix
  figure(2);
  colormap('bone');
  imagesc(mbr);
end
