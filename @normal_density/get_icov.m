function ic = get_icov(obj)

if isempty(obj.icov)
  obj.icov = inv(obj.cov);
end
ic = obj.icov;
