function g = gradient_cov(obj, data, weight, full)
% Returns the gradient of sum_i weight(i)*logProb(data(:, i))
% If weight = 1, returns one gradient per column.

dx = data - repeatcol(obj.mean, cols(data));
ic = inv(obj.cov);
dx = ic*dx;
if nargin < 4
  full = 0;
end
if nargin > 2
  if weight == 1
    d = rows(obj.cov);
    % This loop is a bottleneck.  
    % A C function for computing outer products is needed.
    for i = 1:cols(data)
      outer = dx(:,i)*dx(:,i)';
      if full
	g(:,i) = vec(outer);
      else
	g(:,i) = vech(outer);
      end
    end
    g = 0.5*(g - repeatcol(vec(ic), cols(data)));
    return
  end
  wdx = dx .* repeatrow(weight, rows(data));
  s = wdx * dx';
  n = sum(weight);
else
  s = dx*dx';
  n = cols(data);
end
if full
  g = 0.5*vec(s - ic*n);
else
  g = 0.5*vech(s - ic*n);
end
