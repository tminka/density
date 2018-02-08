function obj = train_counts(obj, data, weight)
% DATA is a matrix of histograms, oriented the same way as obj.a.
% WEIGHT is a vector of numbers in [0,1] (default all ones),
%   oriented opposite the histograms.

a = obj.a;

% initialize
if 0
  if 0 & length(a) == 2
    % this doesn't work very well.  probably because of the need to
    % estimate p beforehand.
    p = (data+1) ./ repmat(col_sum(data)+rows(data),rows(data),1);
    a = johnson_kotz(p(1,:))
  end

  % initialize with moment matching
  % using a smoothed estimate of p can sometimes make the alg fail
  p = data ./ repmat(col_sum(data),rows(data),1);
  a = moment_match(obj, p);
end

if 0
  % plot the objective over alpha
  r = 1:10;
  r1 = [1 1 10]*100;
  r2 = [1 1 10]/10;
  x = lattice([r1; r2]);
  e = [];
  for i = 1:cols(x)
    e(i) = sum(logProb_counts(obj, data, x(:,i)));
  end
  e = reshape(e, length(r), length(r));
  figure(4)
  mesh(r, r, e)
  rotate3d on
  [v,i,j] = max2(e);
  figure(2)
end

if 1
  % alternate betw train_mean and train_var
  use_weight = (nargin >= 3);
  row = (rows(obj.a) == 1);
  if row
    N = rows(data);
    if ~use_weight
      weight = ones(N,1);
    end
  else
    N = cols(data);
    if ~use_weight
      weight = ones(1,N);
    end
  end
  s = sum(obj.a);
  for iter = 1:10
    old_s = s;
    obj = train_mean_counts(obj, data, weight);
    m = obj.a/s;
    obj = train_var_counts(obj, data, weight);
    s = sum(obj.a);
    if ~finite(s)
      s = 1e7;
      obj.a = s*m;
    end
    if abs(s - old_s) < 1e-4
      break
    end
  end
  return
end

if 0
  % fixed-point iteration
  [K,N] = size(data);
  sdata = col_sum(data);
  for iter = 1:1000
    old_a = a;
    sa = sum(a);
    g = row_sum(digamma(data + repmat(a, 1, N))) - N*digamma(a);
    h = sum(digamma(sdata + sa)) - N*digamma(sa);
    a = a .* g ./ h;
    e(iter) = sum(logProb_counts(obj, data, a));
    if max(abs(a - old_a)) < 1e-6
      break
    end
    if rem(iter,10) == 0
      plot(e)
      drawnow
    end
  end    
  plot(e)
  obj.a = a;
  return
end

if 0
  % EM with p hidden
  sdata = col_sum(data);
  for iter = 1:1000
    old_a = a;
    sa = sum(a);
    g = zeros(size(a));
    for i = 1:cols(data)
      g = g + digamma(data(:,i) + a);
    end
    g = g - sum(digamma(sdata + sa));
    g = g/cols(data);
    g = g + digamma(sa);
    a = inv_digamma(g);
    e(iter) = logProb_counts(a, data);
    if max(abs(a - old_a)) < 1e-6
      break
    end
    if rem(iter,10) == 0
      max(abs(a-old_a))
      plot(e)
      drawnow
    end
  end
  plot(e)
  obj.a = a;
  return
end

% Newton-Raphson
old_e = sum(logProb_counts(obj, data, a));
lambda = 0.1;
e = [];
for iter = 1:100
  if sum(a) == 0
    break
  end
  g = gradient(a, data);
  %h = hessian(a,data);
  abort = 0;
  % Newton iteration
  % loop until we get a nonsingular hessian matrix
  while(1)
    hg = hessian_times_gradient(a, data, g, lambda);
    if all(hg < a)
      e(iter) = sum(logProb_counts(obj, data, a - hg));
      if(e(iter) > old_e)
	old_e = e(iter);
	a = a - hg;
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
  a(find(a < eps)) = eps;
  if max(abs(g)) < 1e-16
    break
  end
  if rem(iter,5) == 0
    plot(e)
    drawnow
  end
end
disp(['gradient at exit = ' num2str(max(abs(g)))])
plot(e)
%e(iter)
obj.a = a;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function a = johnson_kotz(p)
% Returns an approximate MLE for the Beta distribution
% p is a vector of samples (probabilities)

a(1,1) = exp(moment1(log(1-p)));
a(2,1) = exp(moment1(log(p)));
s = 1 - sum(a);
a = (1-a)/s/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g = gradient(a, data)

g = zeros(size(a));
sdata = col_sum(data);
sa = sum(a);
for i = 1:cols(data)
  g = g + digamma(data(:,i) + a);
end
g = g - sum(digamma(sdata + sa));
g = g + cols(data)*(digamma(sa) - digamma(a));
g = g/cols(data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g = gradient_approx(a, data)

g = zeros(size(a));
sdata = col_sum(data);
sa = sum(a);
for i = 1:cols(data)
  g = g - Psi_diff(sdata(i), sa);
  g = g + Psi_diff(data(:,i), a);
end
g = g/cols(data);

function x = Psi_diff(n, a)
% approximates Psi(n+a) - Psi(a)

x = 1./a + log((n+a-0.5)./(a+0.5));
i = find(n == 0);
x(i) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h = hessian(a, data)

h = zeros(size(a));
sa = sum(a);
sdata = col_sum(data);
for i = 1:cols(data)
  h = h + trigamma(data(:,i) + a);
end
h = diag(h);
h = h - sum(trigamma(sdata + sa));
h = h + cols(data)*(trigamma(sa) - diag(trigamma(a)));
h = h/cols(data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hg = hessian_times_gradient(a, data, g, lambda)

sa = sum(a);
sdata = col_sum(data);
q = -cols(data)*trigamma(a);
for i = 1:cols(data)
  q = q + trigamma(data(:,i) + a);
end
q = q/cols(data);
z = trigamma(sa) - sum(trigamma(sdata + sa))/cols(data);
q = q - lambda;
q = 1./q;
b = sum(g .* q)/(1/z + sum(q));
hg = (g - b).*q;
