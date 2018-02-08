function p = logProb(obj, x, badvalue)
% each entry ranges from 1 to length(obj.p)

if nargin < 3
  % don't allow values out of range
  badvalue = 0;
end

if badvalue
  i = find(x >= 1 & x <= length(obj.p));
  p = zeros(size(x));
  p(i) = log(obj.p(x(i))+eps);
else
  p = log(obj.p(x) + eps);
  % fix matlab's indexing bug
  if rows(x) == 1
    p = p';
  end
end
