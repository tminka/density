function p = logProb(obj, data)
% data is a cell row (or either cell rows or matrices).

k = obj.degree;
for j = 1:cols(data)
  x = data{j};
  
  if obj.aux_dim > 0
    % aux data is the first few rows of x
    aux = x(1:obj.aux_dim, :);
    x(1:obj.aux_dim, :) = [];
  else
    aux = [];
  end

  p(j) = logProb(obj.initial_density, vec(x(:,1:k)));

  v = seq2lls(obj, x);
  v = [aux(:, (k+1):cols(aux)); v];
  p(j) = p(j) + sum(logProb(obj.prediction_density, v));
end
