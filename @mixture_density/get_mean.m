function m = get_mean(obj)

m = get_mean(obj.components{1}) * obj.weights(1);
for i = 2:length(obj.weights)
  c = obj.components{i};
  m = m + get_mean(c) * obj.weights(i);
end
