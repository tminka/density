function [obj, likelihood] = trainAddOne(obj, x, weight)
% x is a cell row.
% weight is a scalar.

if nargin < 3
  weight = 1;
end

obj.n = obj.n + weight;
[alpha, beta, p, z, likelihood] = classify(obj, x);
% state marginal
mbr = alpha .* beta;

obj.temp_weights = obj.temp_weights + mbr(:, 1)*weight;

% Train each component with the datum, weighted by its responsibility.
for i = 1:length(obj.weights)
  c = obj.components{i};
  obj.components{i} = trainAdd(c, x, mbr(i, :));
end

% update the transition matrix
len = cols(x);
gamma = zeros(size(obj.transitions));
for t = 1:(len-1)
  betax = beta(:, t+1) .* exp(p(:, t+1));
  gamma = gamma + betax * alpha(:, t)' / exp(z(t+1));
end
gamma = gamma .* obj.transitions;
% normalize columns
gamma = gamma ./ repeatrow(sum(gamma), length(obj.weights));

obj.temp_transitions = obj.temp_transitions + gamma*weight;

