function p = logProb(obj, data)

row = (rows(obj.a) == 1);

% add a dummy row or col
if row
  if cols(data) == length(obj.a)-1
    data = [data 1-row_sum(data)];
  end
else
  if rows(data) == length(obj.a)-1
    data = [data; 1-col_sum(data)];
  end
end

w = warning;
warning off
if row
  p = log(data) * (obj.a-1)';
else
  p = (obj.a-1)' * log(data);
end
p = p + gammaln(sum(obj.a)) - sum(gammaln(obj.a));
warning(w)
