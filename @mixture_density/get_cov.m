function v = get_cov(obj)

mi = get_mean(obj.components{1});
v = (get_cov(obj.components{1}) + mi*mi') * obj.weights(1);
m = mi * obj.weights(1);
for i = 2:length(obj.weights)
  c = obj.components{i};
  mi = get_mean(c);
  v = v + (get_cov(c) + mi*mi') * obj.weights(i);
  m = m + mi * obj.weights(i);
end
v = v - m*m';
