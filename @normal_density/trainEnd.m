function [obj,activity] = trainEnd(obj)

activity = 0;

if obj.n == 0
  return
end

old_mean = obj.mean;
new_mean = obj.temp_mean / obj.n;
new_cov = obj.temp_cov / obj.n - new_mean * new_mean';
if strcmp(class(obj.prior), 'normal_wishart_density')
  if ~isnan(get_mean(obj.prior))
    % this code works even if k0 = inf
    k0 = get_k(obj.prior);
    if k0 == 0
      new_mean = obj.temp_mean/obj.n;
    else
      new_mean = (obj.temp_mean/k0 + get_mean(obj.prior)) / (obj.n/k0 + 1);
    end
  end
  obj = set_mean(obj, new_mean);
	activity = norm(obj.mean - old_mean);
elseif strcmp(class(obj.prior), 'normal_density')
  if ~isnan(get_mean(obj.prior))
    if get_cov(obj.prior) == 0
      new_mean = get_mean(obj.prior);
    else
      c = obj.cov / obj.n;
      ic = inv(c + get_cov(obj.prior));
      new_mean = ic*(get_cov(obj.prior)*new_mean + c*get_mean(obj.prior));
    end
  end
  obj = set_mean(obj, new_mean);
	activity = norm(obj.mean - old_mean);
  return
else
  % do nothing; don't change the mean
end

%if isfield(obj, 'phase') & (obj.phase < 1)
%  return
%end
old_cov = obj.cov;
if strcmp(class(obj.prior), 'normal_wishart_density')
  if k0 == 0
    s = zeros(size(obj.temp_cov));
  else
    diff = obj.mean - get_mean(obj.prior);
    s = (obj.n/(obj.n/k0+1)) * (diff*diff');
  end
  n0 = get_n(obj.prior);
  obj.cov = (new_cov*obj.n + get_s(obj.prior) + s)/(obj.n+n0 + 1 + rows(s));
elseif strcmp(class(obj.prior), 'wishart_density')
  new_cov = obj.temp_cov / obj.n - obj.mean * obj.mean';
  k = obj.n + get_n(obj.prior) + 1 + rows(new_cov);
  obj.cov = (new_cov*obj.n + get_s(obj.prior))/k;
else
  warning('no variance prior was specified')
  % use a small Wishart prior to keep the cov from going to zero
  lambda = 1e-10;
  obj.cov = (new_cov * obj.n + lambda * eye(size(obj.cov)))/(obj.n + lambda);
end

if strcmp(obj.cov_type, 'diagonal')
  obj.cov = diag(diag(obj.cov));
elseif strcmp(obj.cov_type, 'spherical')
  obj.cov = eye(rows(obj.cov)) * trace(obj.cov)/rows(obj.cov);
elseif strcmp(obj.cov_type, 'reduced')
  if obj.cov_rank < rows(obj.cov)
    [u,s,v] = svd(obj.cov);
    s = diag(s);
    i = (obj.cov_rank+1):rows(obj.cov);
    if isfield(obj, 'cov_error')
      s(i) = obj.cov_error;
    else
      s(i) = ones(1, length(i)) * mean(s(i));
    end
    s = diag(s);
    obj.cov = u*s*v';
  end
end

activity = max(activity, norm(obj.cov - old_cov));


