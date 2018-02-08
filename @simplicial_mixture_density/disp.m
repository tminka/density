function disp(obj)

disp('Prototype = ')
disp(obj.prototype)
disp('Corners = ')
for i = 1:length(obj.corners)
  disp(obj.corners{i})
end
disp('Weight density = ')
disp(obj.weight_density)
