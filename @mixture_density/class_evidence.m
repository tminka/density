function p = class_evidence(obj, x, c)

if nargin < 3
  % the last row is the class index
  c = x(rows(x), :);
  x = x(1:(rows(x)-1), :);
end

if isa(c, 'cell')
  c = cat(2, c{:});
end

p = 0;
for i = 1:length(c)
  if obj.weights(c(i)) > 0
    ind = find(c == i);
    if ~isempty(ind)
      if isa(x, 'cell')
	t = cat(2, x{ind});
      else
	t = x(:, ind);
      end
      p = p + evidence(obj.components{i}, t);
    end
  end
end
