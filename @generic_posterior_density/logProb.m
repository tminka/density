function p = logProb(obj, data)
% data is a cell array

if isa(data, 'double')
  % convert to cell array
  data = num2cell(data, 1);
end

for i = 1:length(data)
  if rem(i, 1000) == 1
    i
  end
  temp = feval(obj.set_func, obj.likelihood_obj, data{i});
  p(i) = sum(logProb(temp, obj.likelihood_args{:}));
end

if isfield(obj, 'prior')
  p = p + logProb(obj.prior, data);
end
