function x = sample(obj, n)
% This is a specialization of mixture_density/sample

if nargin < 2
  n = 1;
end

% Choose a component
h = sample_hist(obj.weights, n);

x = [];
for i = 1:length(obj.weights)
  if h(i) > 0
    x = [x randnorm(h(i), obj.means(:, i), [], obj.cov)];
  end
end
% jumble up the results
x = x(:, randperm(n));
