function h = hessian(obj, data, weight, hessian_func, gradient_func)
% Returns the Hessian of sum_i weight(i)*logProb(data(:, i))

mbr = classify(obj, data);
if nargin > 2
  mbr = mbr .* repeatrow(weight, length(obj.weights));
end
if nargin < 4
  hessian_func = 'hessian';
end
if nargin < 5
  gradient_func = 'gradient';
end
g = [];
for i = 1:length(obj.weights)
  c = obj.components{i};
  hc = feval(hessian_func, c, data, mbr(i, :));
  % gc is collection of gradients for each data point
  gc = feval(gradient_func, c, data, 1);
  wgc = gc .* repeatrow(mbr(i, :), rows(gc));
  if 1
    hc = hc + wgc*gc';
  end
  if i == 1
    h = hc;
  else
    h = directsum(h, hc);
  end
  g = [g; wgc];
end
if 1
h = h - g*g';
end

% for now, we omit the weight hessian
