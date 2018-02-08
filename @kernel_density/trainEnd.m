function obj = trainEnd(obj)

% need a pruning alg when there is a lot of centers
obj.centers = obj.temp_centers;
obj.weights = obj.temp_weights;

% Normalize weights
if sum(obj.weights) > 0
  obj.weights = obj.weights / sum(obj.weights);
end

if isfield(obj, 'width_type') & strcmp(obj.width_type, 'fixed')
  return
end

% Find the optimal width

% Find a good interval for search
% Here we want a bracket routine like in src/matrix/src/brent.c

if 0
  % brute force
  widths = 0.1:0.1:4;
  e = [];
  for i = 1:length(widths)
    width = widths(i);
    e(i) = kernel_width_cv(width, obj.centers, obj.weights);
  end
  figure(2)
  plot(widths, e);
  axis tight
  [v,i] = min(e);
  obj.width = widths(i);
else
  % line search
  obj.width = fminbnd('kernel_width_cv', 1e-2, 1e3, optimset('TolX',1e-1), obj.centers, obj.weights);
end

