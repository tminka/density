function [alphas, betas, p, z, likelihood] = classify(obj, x)
% x is a single observation sequence; either a cell row or matrix.
% alphas and betas run from time 1 to T.
% p(s, t) is log(p(x_t | s_t = s)).
% z(t) is log(p(x_t | x_1 .. x_{t-1})), i.e. the scaling factor.
% likelihood is the same as logProb(obj, x).

len = cols(x);
k = length(obj.weights);

% precompute the data probabilities
% loop states
for i = 1:k
  c = obj.components{i};
  p(i, :) = logProb(c, x);
end

% forward pass (same as in logProb)
% z is the logarithm of the scaling factors
alpha = obj.weights;
for t = 1:len
  alpha = log(alpha) + p(:, t);
  % s is the logarithm of the sum of alphas
  s = logSum(alpha);
  alpha = exp(alpha - s);
  z(t) = s;

  alphas(:, t) = alpha;

  % not needed on the last step (unless we're doing prediction)
  alpha = obj.transitions * alpha;
end
likelihood = sum(z);

% backward pass
beta = ones(size(obj.weights));
for t = len:-1:1
  betas(:, t) = beta;
  beta = beta .* exp(p(:, t));
  beta = sum(obj.transitions .* repeatcol(beta, k))' / exp(z(t));
end
