function obj = set_cov(obj, cov)

obj.cov = cov;
obj.icov = inv(cov);
