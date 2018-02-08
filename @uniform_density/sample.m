function data = sample(obj, n)
% n is the number of samples (optional).

if nargin < 2
  n = 1;
end
data = rand(length(obj.a), n).*repeatcol(obj.b-obj.a,n) + repeatcol(obj.a, n);
