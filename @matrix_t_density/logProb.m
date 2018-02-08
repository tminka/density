function p = logProb(obj, data, k)
% returns the log-probability of the whole matrix of data.

d = rows(data);
if nargin < 3
  k = cols(data);
end
p = d/2*log(obj.n/(obj.n+k)) -k/2*logdet(pi*obj.v);
for i = 1:d
  p = p + gammaln((obj.n + k + 1 - i)/2) - gammaln((obj.n + 1 - i)/2);
end
if cols(obj.m) == 1
  diff = data - repmat(obj.m, 1, cols(data));
else
  diff = data - obj.m;
end
p = p - (obj.n+k)/2*logdet(diff'*inv(obj.v)*diff*obj.c + eye(cols(data)));
