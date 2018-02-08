function obj = train_var_counts(obj, data, weight)
% Trains only the variance (the sum of the parameters).
% DATA is a matrix of histograms, oriented the same way as obj.a.
% WEIGHT is a vector of numbers in [0,1] (default all ones),
%   oriented opposite the histograms.

show_progress = 0;

s = sum(obj.a);
m = obj.a/s;

row = (rows(obj.a) == 1);
if row
  sdata = row_sum(data);
else
  [K,N] = size(data);
  sdata = col_sum(data);
end

use_weight = (nargin > 2);

if 0
  % plot the objective over s
  inc = 0.1;
  ss = inc:inc:10;
  for i = 1:length(ss)
    obj.a = m*ss(i);
    e(i) = sum(logProb_counts(obj, data));
  end
  figure(4)
  plot(ss, e)
end

e = [];
for iter = 1:10
  old_s = s;
  if 0
    g = row_sum(digamma(data + repmat(s*m, 1, N))) - N*digamma(s*m);
    g = sum(m.*g);
    h = sum(digamma(s+sdata)) - N*digamma(s);
    a = s*g/h;
  else
    if row
      if use_weight
	[g,h,c1,c3] = s_derivatives(obj, data, sdata, weight);
      else
	[g,h,c1,c3] = s_derivatives(obj, data, sdata);
      end
    else
      if use_weight
	[g,h,c1,c3] = s_derivatives(obj, data', sdata', weight');
      else
	[g,h,c1,c3] = s_derivatives(obj, data', sdata');
      end
    end      
    if g > eps
      r = g + s.*h;
      if r >= 0
	% the maximum is infinity
	s = Inf;
      else
	s = s./(1 + g./h./s);
      end
    end
    if g < -eps & c1 > eps
      s = special_case(s, g, h, c1, c3);
    end  
  end
  obj.a = s*m;
  if show_progress
    p = logProb_counts(obj, data);
    if use_weight
      p = p.*weight;
    end
    e(iter) = sum(p);
  end
  if show_progress & rem(iter,10) == 0
    figure(2)
    plot(e)
    drawnow
  end
  if ~finite(s) | abs(s - old_s) < 1e-6
    break
  end
end
if show_progress 
  figure(2)
  plot(e)
end
%e(iter)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = special_case(s, g, h, c1, c3)

a1 = h.*s.^2 + c1;
a2 = 2*s.^2.*(h.*s + g);
a3 = s.^3.*(2*g + h.*s);
if abs(2*g + h.*s) < 1e-13
  a3 = c3;
end
b = quad_roots(a1, a2, a3);
a = (g./c1).*((s+b)./b).^2;
% 1/s = 1/s - a
s = 1./(1./s - a);
