function p = logProb_bound(obj, x, mbr)

dists = distance(obj.means, x, obj.icov);
p = -dists/2 + repmat(log(obj.weights(:)), 1, cols(data));
p = col_sum(mbr .* p) - sum(sum(mbr .* log(mbr+eps)));
p = p + 0.5*log(det(obj.icov)) - rows(obj.icov)/2*log(2*pi);
