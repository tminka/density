function x = sample(obj, n)

if nargin < 2
  n = 1;
end
x = gamrnd(obj.a, obj.b, 1, n);
