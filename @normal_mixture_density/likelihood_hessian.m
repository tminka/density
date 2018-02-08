function h = likelihood_hessian(obj, data)

mbr = classify(obj, data);
j = length(obj.weights);
d = rows(obj.means);
if 1
  g = likelihood_gradient(obj, data, 1);
  h = [];
  wg = [];
  for i = 1:j
    gi = g((i*d-d+1):(i*d), :);
    wgi = gi .* repeatrow(mbr(:,i)', d);
    wg = [wg; wgi];
    h = directsum(h, gi * wgi');
  end
  h = h - wg * wg';
else
  h = zeros(j*d);
end
N = col_sum(mbr);
h = h - kron(diag(N), obj.icov);
