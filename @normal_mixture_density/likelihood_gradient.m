function g = likelihood_gradient(obj, data, w)

j = length(obj.weights);

if nargin > 2
  % give gradient for each sample
  diff = kron(ones(j,1), data) - repeatcol(vec(obj.means), cols(data));
  g = kron(eye(j), obj.icov) * diff;
  return
end

mbr = classify(obj, data);
for i = 1:j
  g(:, i) = (data - repeatcol(obj.means(:, i), cols(data))) * mbr(:,i);
end
g = vec(obj.icov * g);
