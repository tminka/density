function p = logProb(obj, data)
% The result is valid even when obj.n == 0 (i.e. noninformative prior)

% break into separate parts
d = length(obj.mean);
means = data(1:d, :);
covs = data((d+1):end, :);

d = rows(means);
for i = 1:cols(means)
  m = means(:, i);
  diff = m - obj.mean;
  c = reshape(covs(:, i), size(obj.s));
  if isposdef(c)
    dc = det(c);
    ic = inv(c);
    p(i) = (obj.n + d + 2)*log(dc);
    if obj.n > 0
      p(i) = p(i) + trace(obj.s*ic) + obj.k * diff' * ic * diff;
    end
  else
    p(i) = Inf;
  end
end
if obj.k > 0 && obj.n > d-1
  % normalization term
  p = p + d*log(2*pi/obj.k);
  p = p - obj.n*logdet(obj.s);
  p = p + 2*wishart_z(obj.n, d) + d*obj.n*log(2);
else
  %warning('density is improper')
end
p = -p/2;
