function [obj, likelihood] = trainAddOne(obj, x, weight)
% x is a cell row.
% weight is a scalar.

if nargin < 3
  weight = 1;
end

obj.n = obj.n + weight;
[means, vars, covs, likelihood] = classify(obj, x);
if 0
  figure(2)
  plot(means(1, :), means(2, :), 'o');
  if rows(means) >= 4
    figure(11);
    plot(means(3, :), means(4, :), 'o');
  end
end

if isa(x, 'cell')
  % convert to a matrix (2 means horizontal concatenation)
  x = cat(2, x{:});
end
[d, len] = size(x);

% prior_state %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if obj.train_prior_state

obj.prior_state = trainAdd(obj.prior_state, means(:, 1), weight, vars(:, 1));

end

% emission_density %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if obj.train_emission

for i = 1:len
  v = reshape(vars(:, i), rows(means), rows(means));
  vs(:, i) = vec(directsum(v, zeros(d)));
end
% learn a mapping from the state estimates to the observations
obj.emission_density = trainAdd(obj.emission_density, ...
    [means; x], repeatcol(weight, len), vs);

end

% transition_density %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vs = [];
for t = 1:(len-1)
  v1 = reshape(vars(:, t), rows(means), rows(means));
  v2 = reshape(vars(:, t+1), rows(means), rows(means));
  c = reshape(covs(:, t), rows(means), rows(means));
  vs(:, t) = vec([v1 c; c' v2]);
end
% learn a mapping from one state estimate to the next
ms = [means(:, 1:(len-1)); means(:, 2:len)];
obj.transition_density = trainAdd(obj.transition_density, ...
    ms, repeatcol(weight, len-1), vs);
