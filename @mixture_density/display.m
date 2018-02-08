function display(obj)

for i = 1:length(obj.weights)
  c = obj.components{i};
  disp(['Component ' num2str(i) ': ' class(c) ...
	' (weight = ' num2str(obj.weights(i)) ')']);
  display(c);
end
