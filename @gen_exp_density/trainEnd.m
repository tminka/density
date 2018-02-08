function obj = trainEnd(obj)

if 0
  obj.b = 2;
  obj.mean = (obj.temp_data * obj.temp_weights') / obj.n;
else
  obj.b = 1;
  obj.mean = median(obj.temp_data);
end
if 1
  while(1)
    old_b = obj.b;
    old_m = obj.mean;
    
    % optimize b (most time is spent here)
    x = obj.temp_data - obj.mean;
    obj.b = fmin('gen_exp_train_fcn', 1e-2, 1e2, [0 1e-1], ...
	x, obj.temp_weights, obj.mean, 'b');
    
    % optimize mean
    s = abs(obj.mean);
    obj.mean = fmin('gen_exp_train_fcn', obj.mean-s, obj.mean+s, [0 1e-1], ...
	obj.temp_data, obj.temp_weights, obj.b, 'm');
    
    % this loop generally runs twice; you can break right away for extra speed
    break
    if norm(old_b - obj.b) + norm(old_m - obj.mean) < 1e-1
      break
    end
  end
else
  obj.mean = 0;
  bs = 1:100;
  for i = 1:length(bs)
    e(i) = gen_exp_train_fcn(bs(i), obj.temp_data, obj.temp_weights);
  end
  figure(3)
  plot(bs, e);
  [y,i] = min(e);
  obj.b = bs(i);
end
x = obj.temp_data - obj.mean;
obj.c = obj.b/obj.n * (abs(x).^obj.b * obj.temp_weights');
obj.c = obj.c^(1/obj.b);

% free the memory
obj.temp_data = [];
obj.temp_weights = [];
