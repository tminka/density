function count = class_counts(x, maxk, c, maxc)

if isa(c, 'cell')
  c = cat(2, c{:});
end

% count(k,j) is #k's assigned to class j
for j = 1:maxc
  ind = find(c == j);
  if isempty(ind)
    count(:,j) = zeros(maxk,1);
  else
    t = cat(2, x{ind});
    count(:,j) = hist_int(t, maxk)';
  end
end
