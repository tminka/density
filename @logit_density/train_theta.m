function [obj, p] = train_theta(obj)

% include this to retry and get closer to true maximum
%obj.theta = obj.theta/10;

if 0
  % path(path,'/u/tpminka/matlab/neural')
  obj.theta = fmin_cg('logit_logProb', obj.theta, [0], 'logit_gradient_theta', obj, obj.data);
  sum(logProb(obj, obj.data))
  return
end

if 0
  % check the gradient and hessian computation
  obj.theta = [-4; -3];
  x = -5:0.1:-3;
  e = [];
  d = 1;
  for i = 1:length(x)
    obj.theta(d) = x(i);
    e(i) = prior_theta_logProb(obj, obj.theta);
    grad = gradient_prior(obj, obj.data);
    g(i) = grad(d);
    hess = hessian_prior(obj, obj.data);
    h(i) = hess(d,d);
  end
  if 0
    figure(6);
    plot(x, e, x, g, x, h);
    legend('prior', 'gradient', 'hessian');
  end
end

if 0
  angle = 1.1;
  obj.theta = [sin(angle); cos(angle)]*20;
  figure(1);
  delete(findobj('Tag', 'logit_density', 'Color', [1 0 0]));
  draw(obj, 'r');
  return
end

%rate = 1/sum(obj.weight)*2;
%rate = 0.5;
e = [];
lambda = 0.1;
old_e = sum(logProb(obj, obj.data));
old_e = old_e + prior_theta_logProb(obj, obj.theta);
for iter = 1:200
  old_theta = obj.theta;
  h = 0;
  if 1
    h = -likelihood_hessian_theta(obj, obj.data, obj.weight);
  end
  h = h-hessian_prior(obj, obj.data);
  g = 0;
  if 1
    g = gradient_theta(obj, obj.data, obj.weight);
  end  
  g = g + gradient_prior(obj, obj.data);
  abort = 0;
  % Newton-Raphson with Marquardt's trust region
  while(1)
    h2 = h + lambda*eye(size(h));
    if rcond(h2) > eps
      delta = h2\g;
      % use this for gradient descent
      %delta = g/lambda;
      obj.theta = old_theta + delta;
      e(iter) = sum(logProb(obj, obj.data));
      e(iter) = e(iter) + prior_theta_logProb(obj, obj.theta);
      if(e(iter) > old_e)
	old_e = e(iter);
	lambda = lambda/10;
	break
      end
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
  if max(abs(delta)) < eps
    break
  end
  
  if 0 && rem(iter, 10) == 1
    figure(1);
    delete(findobj('Tag', 'logit_density', 'Color', [1 0 0]));
    draw(obj, 'r');

    figure(3);
    plot(e);
    drawnow
  end
end
if 0
  figure(1);
  delete(findobj('Tag', 'logit_density', 'Color', [1 0 0]));
  %draw(obj, 'r');
  figure(3);
  plot(e);
end

p = e(iter);
