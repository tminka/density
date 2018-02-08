function obj = trainEnd(obj)

debug = 0;
[d,m] = size(obj.prediction_matrix);
xi = 1:m;
yi = (m+1):(m+d);

obj.temp_mean = obj.temp_mean / obj.n;
obj.mx = obj.temp_mean(xi);
obj.my = obj.temp_mean(yi);

%obj.temp_cov = obj.temp_cov / obj.n;
obj.sxx = obj.temp_cov(xi, xi);
obj.syx = obj.temp_cov(yi, xi);
obj.syy = obj.temp_cov(yi, yi);

% n is the actual number of samples, while obj.n is the effective number
n = obj.n;

if isa(obj.prior, 'normal_wishart_density')
  obj.n = obj.n + get_n(obj.prior);
  obj.sxx = obj.sxx + get_k(obj.prior);
  obj.syx = obj.syx + get_mean(obj.prior)*get_k(obj.prior);
  obj.syy = obj.syy + ...
      get_mean(obj.prior)*get_k(obj.prior)*get_mean(obj.prior)';
  s0 = get_s(obj.prior);
end

if strcmp(obj.offset_type, 'fixed')

  % (y - b)*x' = y*x' - b*x'
  obj.syx = obj.syx - n*obj.offset * obj.mx';
  % (y - b)*(y - b)' = y*y' - b*y' - y*b' + b*b'
  obj.syy = obj.syy - n*obj.offset*obj.my' - n*obj.my*obj.offset' ...
      + n*obj.offset*obj.offset';

  obj.prediction_matrix = obj.syx / obj.sxx;

  if ~strcmp(obj.cov_type, 'fixed')
    % cov is not fixed
    if ~isobject(obj.prior)
      alpha = 0.005;
      n0 = 1;
      for iter = 1:10
	old_alpha = alpha;
	a = obj.prediction_matrix/(alpha+1);
	syx = obj.syy - a * obj.syx';
	obj.n0 = n0;
	n0 = best_n0(obj, syx, n);
	v = (syx + n0*eye(d))/(n+n0);
	alpha = trace(inv(v)*obj.prediction_matrix*obj.syx')/m/d;
	alpha = 1/(alpha - 1);
	if alpha < 0
	  alpha = Inf;
	end
	if abs(alpha - old_alpha) < 1e-4
	  break
	end
      end
      obj.alpha = alpha;
      obj.n0 = n0;
      
      if debug
	disp(['alpha = ' num2str(obj.alpha)])
      end
      obj.sxx = obj.sxx*(obj.alpha+1);
      obj.prediction_matrix = obj.prediction_matrix/(obj.alpha + 1);
      if debug
	disp(['n0 = ' num2str(obj.n0)]);
      end
      s0 = obj.n0*eye(d);
      obj.n = n + obj.n0;
    end
    obj.cov = (obj.syy - obj.prediction_matrix * obj.syx' + s0)/obj.n;
  else
    % cov is fixed
    if ~isobject(obj.prior)
      obj.alpha = trace(inv(obj.cov)*obj.prediction_matrix*obj.syx')/m/d;
      obj.alpha = 1/(obj.alpha - 1);
      if obj.alpha < 0
	obj.alpha = Inf;
      end
      if debug
	disp(['alpha = ' num2str(obj.alpha)])
      end
      obj.sxx = obj.sxx*(obj.alpha+1);
      obj.prediction_matrix = obj.prediction_matrix/(obj.alpha + 1);
    end
  end
  
else
  
  obj.sxx = obj.sxx - n*obj.mx*obj.mx';
  obj.syx = obj.syx - n*obj.my*obj.mx';
  obj.syy = obj.syy - n*obj.my*obj.my';

  if obj.n > 1
    obj.prediction_matrix = obj.syx / obj.sxx;
    obj.offset = obj.my - obj.prediction_matrix * obj.mx;
    if ~strcmp(obj.cov_type, 'fixed')
      obj.cov = (obj.syy - obj.prediction_matrix * obj.syx')/obj.n;
    end
  else
    % There is no maximum-likelihood estimate in this case,
    % so arbitrarily set the prediction matrix to zero and
    % the output covariance to the identity.
    obj.prediction_matrix = zeros(size(obj.prediction_matrix));
    obj.offset = obj.my;
    obj.cov = eye(size(obj.cov));
  end

end

if isfield(obj, 'ridge_type')
  % this must be sxx, not rxx
  [v,e] = sorted_eig(obj.sxx);
  e = diag(e);
  % normalized OLS coeffs
  a = obj.prediction_matrix*v;
  f = e.*vec(a.^2) ./ obj.cov;
  if strcmp(obj.ridge_type, 'troskie')
    delta = (f + 1) ./ (f + 2);
  elseif strcmp(obj.ridge_type, 'hemmerle')
    delta = f ./ (f + 1);
  elseif strcmp(obj.ridge_type, 'pc')
    delta = zeros(size(f));
    delta(1) = 1;
  elseif strcmp(obj.ridge_type, 'dempster')
    k = fmin('dempster_ridge_fcn', 0, 1e2, [], a, e, ...
	obj.cov*obj.n/(obj.n - xd));
    if k == 1e2
      error('reached k limit')
    end
    delta = e ./ (e + k);
    if 0
      for k = 1:100
	f(k) = dempster_ridge_fcn(k, a, e, obj.cov);
      end
      clf
      plot(f)
      pause
    end
  elseif strcmp(obj.ridge_type, 'stein')
    k = fmin('dempster_stein_fcn', 0, 1e2, [], a, e, ...
	obj.cov*obj.n/(obj.n - xd));
    if k == 1e2
      error('reached k limit')
    end
    delta = 1 ./ (1 + k*ones(size(e)));
    if 0
      for k = 1:100
	f(k) = dempster_stein_fcn(k, a, e, obj.cov);
      end
      clf
      plot(f)
      pause
    end
  else
    error('unknown ridge_type')
  end
  obj.prediction_matrix = a*diag(delta)*v';
  obj.delta = delta;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function n0 = best_n0(obj, syx, n)

[d,m] = size(obj.prediction_matrix);
n0 = obj.n0;
for iter = 1:100
  old_n0 = n0;
  s0 = n0*eye(d);
  v = (syx + s0)/(n+n0);
  z = 0;
  for i = 1:d
    z = z + digamma((n+n0+1-i)/2) - digamma((n0+1-i)/2);
  end
  if 1
    % fixed-point iteration
    n0 = d-1 + (n0+1-d)*z/(logdet(syx/n0 + eye(d)) + trace(inv(v)) - d);
  else
    g = z - n*d/n0 + trace(inv(v)*syx)/n0 - logdet(syx/n0 + eye(d));
    if 0
      % gradient descent
      n0 = n0 + g;
    else
      % Newton
      z = 0;
      for i = 1:d
	z = z + trigamma((n+n0+1-i)/2) - trigamma((n0+1-i)/2);
      end
      h = z/2 + n*d/n0^2 - trace(inv(v)*syx)*(n-n0)/(n+n0)/n0^2 ...
	  - trace(inv(v)*inv(v)*syx)/n0/(n+n0);
      step = g/h;
      lambda = h;
      while(step > n0)
	step = g/(h + lambda);
	lambda = lambda*10;
      end
      n0 = n0 - step
    end
  end
  if abs(n0 - old_n0) < 1e-4
    break
  end
end
