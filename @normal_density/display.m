function display(obj)

disp('mean = ');
disp(obj.mean);
disp('cov = ');
disp(obj.cov);
if ~isempty(obj.cov_type)
  disp(['cov_type = ' obj.cov_type]);
end
