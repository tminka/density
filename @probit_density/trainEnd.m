function [obj,p] = trainEnd(obj)

if 0
  obj = trainEM(obj);
  return
end

data = obj.data;

lambda = 0.1;
e = [];
old_e = sum(logProb(obj, data));
old_e = old_e + logProb(obj.prior, obj.w);
for iter = 1:200
  old_w = obj.w;

  % gradient
  s = obj.w'*data;
  p = normcdf(s);
  pp = mvnormpdf(s, 0, 1);
  q = pp./p;
  g = data * q';
  % gradient of prior
  g = g - get_icov(obj.prior)*obj.w;
  % hessian
  if 0
    ppp = -s.*pp;
    h = data * diag(ppp./p - q.^2) * data';
  else
    % Bohning's bound (identical to EM update)
    h = -data * data';
  end
  % hessian of prior
  h = h - get_icov(obj.prior);
  
  abort = 0;
  % Newton-Raphson with Marquardt's trust region
  while(1)
    delta = (h + lambda*eye(size(h)))\g;
    %delta = lambda\g;
    obj.w = old_w - delta;
    e(iter) = sum(logProb(obj, data));
    e(iter) = e(iter) + logProb(obj.prior, obj.w);
    if(e(iter) > old_e)
      old_e = e(iter);
      lambda = lambda/10;
      break
    end
    lambda = lambda*10;
    if lambda > 1e+6
      abort = 1;
      break
    end
  end
  if abort
    disp('Search aborted')
    e(iter) = old_e;
    break
  end
  % no change?
  if max(abs(delta)) < 1e-4
    break
  end
  
  if rem(iter, 10) == 1
    figure(1);
    delete(findobj('Tag', 'probit_density', 'Color', [1 0 0]));
    draw(obj, 'r');

    figure(3);
    plot(e);
    drawnow
  end
end
figure(1);
delete(findobj('Tag', 'probit_density', 'Color', [1 0 0]));
%draw(obj, 'r');
figure(3);
plot(e);

p = e(iter)
