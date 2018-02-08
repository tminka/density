function obj = trainEnd(obj)

obj = train_theta(obj);
if strcmp(obj.e_type, 'fixed')
  return
end

% e is not fixed
p = [];
for iter = 1:10
  old_e = obj.e;
  obj = train_e(obj);
  e = obj.e
  if norm(obj.e - old_e) < 1e-2
    break
  end
  [obj, p(iter)] = train_theta(obj);
  if 0
    figure(6)
    plot(p);
  end
end
