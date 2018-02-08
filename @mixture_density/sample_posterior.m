function densities = sample_posterior(obj, n)
% Returns a cell array of n densities.
% This is not a true sample from the posterior, but only a random step
% away from the current parameter values.
% Next version should use data and sample the assignments.

if nargin < 2
  n = 1;
end
densities = cell(1, n);

for t = 1:n
  components = cell(length(obj.weights), 1);
  for i = 1:length(obj.weights)
    c = obj.components{i};
    components{i} = sample_posterior(c);
  end
  % should sample the weights, too
  densities{t} = mixture_density(obj.weights, components{:});
end
if nargin < 2
  densities = densities{1};
end
