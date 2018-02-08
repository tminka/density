function [obj,p] = trainEM(obj)

data = obj.data;

e = [];
for iter = 1:200
  old_w = obj.w;
  
  s = obj.w'*data;
  p = normcdf(s);
  pp = normpdf(s, 0, 1);
  q = s + pp./p;
  %q = s - pp./(1 - p);
  if 0
    obj.w = (q/data)';
  else
    obj.w = q*data'*inv(data*data' + get_icov(obj.prior));
  end
  e(iter) = sum(logProb(obj, data));
  e(iter) = e(iter) + logProb(obj.prior, obj.w);
  delta = obj.w - old_w;
  
  % no change?
  if max(abs(delta)) < 1e-4
    break
  end

  if rem(iter, 10) == 1
    figure(3);
    plot(e);
    drawnow
  end
end
figure(3);
plot(e);
p = e(iter)
