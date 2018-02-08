function obj = set_cov_type(obj, type, rank, e)
% type can be 'fixed', 'diagonal', 'spherical', or 'reduced'.
% The latter requires an extra argument for the desired rank,
% and another optional argument for the value to use for the
% remaining eigenvalues (otherwise their average is used).

obj.cov_type = type;
if strcmp(type, 'reduced')
  obj.cov_rank = rank;
  if nargin > 3
    obj.cov_error = e;
  end
end
