function obj = train_mean_counts(obj, data, weight)
% DATA is a matrix of histograms, oriented the same way as obj.a.
% WEIGHT is a vector of numbers in [0,1] (default all ones),
%   oriented opposite the histograms.

s = sum(obj.a);
m = obj.a/s;
[K,N] = size(data);

use_weight = (nargin > 2);

if 0
  % initialize
  m = row_sum(data);
  m = m/sum(m);
end

if 0
  % fixed-point iteration
  e = [];
  for iter = 1:1000
    old_m = m;
    b = row_sum(digamma(data + repmat(a*m, 1, N))) - N*digamma(a*m);
    m = m .* b;
    m = m/sum(m);
    e(iter) = sum(logProb_counts(obj, data, a*m));
    if max(abs(m - old_m)) < 1e-6
      break
    end
    if rem(iter, 10) == 0
      figure(2)
      plot(e)
    end
  end
  figure(2)
  plot(e)
  obj.a = a*m;
  return
end

if 1
  row = (rows(obj.a) == 1);
  if row
    if use_weight
      obj.a = train_mean_counts_c(obj, data, weight);
    else
      obj.a = train_mean_counts_c(obj, data);
    end
    return
  end
  for iter = 1:20
    old_m = m;
    if row
      a = s*m;
      for k = 1:length(m)
	dk = data(:,k);
	vdk = a(k)*di_pochhammer(a(k), dk);
	if use_weight
	  vdk = vdk .* weight;
	end
	m(k) = sum(vdk) + 1e-10;
      end
    else
      a = repmat(s*m, 1, N);
      vdata = a.*di_pochhammer(a, data);
      if use_weight
	vdata = vdata .* repmat(weight, rows(vdata), 1);
      end
      m = row_sum(vdata) + 1e-10;
    end
    m = m ./ sum(m);
    if max(abs(m - old_m)) < 1e-4
      break
    end
  end
  obj.a = s*m;
  return
end

lambda = 1e-4;
old_e = sum(logProb_counts(obj, data, a*m));
e = [];
for iter = 1:1000
  g = gradient(m, a, data);
  [h,z] = hessian(m, a, data);
  abort = 0;
  while(1)
    new_m = m - hessian_times_gradient(m, a, data, g, h, z, lambda);
    new_m(K) = 1-sum(new_m)+new_m(K);
    e(iter) = sum(logProb_counts(obj, data, a*new_m));
    if(e(iter) > old_e)
      old_e = e(iter);
      m = new_m;
      lambda = lambda/10;
      break;
    end
    lambda = lambda*10;
    if lambda > 1e+6*a
      abort = 1;
      break;
    end
  end
  if abort
    disp('Search aborted')
    e(iter) = old_e;
    break
  end
  if max(abs(g)) < 1e-16
    break
  end
  if rem(iter,10) == 0
    figure(2)
    plot(e)
    drawnow
  end
end
disp(['gradient on exit = ' num2str(max(abs(g)))])
figure(2)
plot(e)
obj.a = a*m;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hg = hessian_times_gradient(m, a, data, g, h, z, lambda)

h = h - lambda;
K = length(m);
g = g(1:(K-1));
h = 1./h;
b = sum(g .* h)/(1/z + sum(h));
hg = (g - b).*h;
hg(K) = 0;
hg = hg(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [h,z] = hessian(m, a, data)

K = length(m);
if 1
  h = zeros(K,1);
  for i = 1:cols(data)
    h = h + trigamma(data(:,i) + a*m) - trigamma(a*m);
  end
  h = h/cols(data);
else
  % EM hessian
  h = -trigamma(a*m);
end
h = (a*a)*h;
z = h(K);
h = h(1:(K-1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g = gradient(m, a, data)
% returns the gradient wrt the elements of m except the last

K = length(m);
g = zeros(K,1);
for i = 1:cols(data)
  g = g + digamma(data(:,i) + a*m) - digamma(a*m);
end
g = g/cols(data);
g = g - g(K);
g = a*g;
