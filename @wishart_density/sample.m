function x = sample(obj, n)
% n is the number of samples (optional).
% This algorithm is taken from BUGS.
% The idea is to sample from W(n, 1) and then make an affine transformation.

if nargin < 2
  n = 1;
end
d = rows(obj.s);

if d == 1
  x = gamrnd(obj.n/2, 2/obj.s, 1, n);
  if obj.inverse
    x = 1./x;
  end
  if n > 1
    x = num2cell(x);
  end
  return
end

% the rest is verified correct for d = 1

cov_root = eig_root(pinv(obj.s));

x = cell(1, n);
for i = 1:n
  
  r = triu(randn(d), 1);
  %r = zeros(d);
  a = (obj.n - (0:(d-1)))/2;
  e = gamrnd(a, 2);
  er = diag(sqrt(e)) * r;
  c = diag(e) + er + er' + r'*r;
  
  % shape it
  c = cov_root * c * cov_root';
  if obj.inverse
    ic = pinv(c);
    c = ic;
  end
  
  x{i} = c;
end
if n == 1
  x = x{1};
end
