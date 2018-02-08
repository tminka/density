function display(obj)

disp('theta = ');
disp(obj.theta);

disp('e = ');
disp(obj.e);

if ~isempty(obj.e_type)
  disp(['e_type = ' obj.e_type]);
end
