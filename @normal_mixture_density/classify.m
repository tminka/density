function [mbr, likelihood] = classify(obj, data)

dists = distance(obj.means, data, obj.icov);
mbr = -dists/2 + repmat(log(obj.weights(:)), 1, cols(data));
p = logSum(mbr);
mbr = mbr - repmat(p, rows(e), 1);
mbr = exp(mbr);
if nargout > 1
  likelihood = p + 0.5*log(det(obj.icov)) - rows(obj.icov)/2*log(2*pi);
end
