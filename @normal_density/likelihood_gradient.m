function g = likelihood_gradient(obj, data, weight)

dx = data - repeatcol(obj.mean, cols(data));
if nargin < 3
  % weight is implicitly a vector of ones
  weight = ones(1, cols(data));
end
gm = inv(obj.cov) * (dx * weight');

if strcmp(class(obj.prior), 'normal_density')
  g = gm;
  return
end

ic = inv(obj.cov);
icdx = ic*dx;
if nargin < 4
  full = 0;
end
if nargin > 2
  if weight == 1
    d = rows(obj.cov);
    % This loop is a bottleneck.  
    % A C function for computing outer products is needed.
    for i = 1:cols(data)
      outer = icdx(:,i)*icdx(:,i)';
      if full
        gc(:,i) = vec(outer);
      else
        gc(:,i) = vech(outer);
      end
    end
    gc = 0.5*(gc - repeatcol(vec(ic), cols(data)));
    g = [gm; gc];
    return
  end
  wicdx = icdx .* repeatrow(weight, rows(data));
  s = wicdx * icdx';
  n = sum(weight);
else
  s = icdx*icdx';
  n = cols(data);
end
if full
  gc = 0.5*vec(s - ic*n);
else
  gc = 0.5*vech(s - ic*n);
end
g = [gm; gc];
