function obj = trainAdd(obj, data, weight)
% each column of data is a histogram

if nargin < 3
  weight = ones(1, length(data));
end

for i = 1:length(data)
  obj.counts = obj.counts + data(:,i) * weight(i);
  obj.n = obj.n + sum(data(:,i)) * weight(i);
end
