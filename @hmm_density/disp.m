function disp(obj)

disp('Transitions = ');
disp(obj.transitions);
for i = 1:length(obj.weights)
  c = obj.components{i};
  disp(['State ' num2str(i) ': ' class(c) ...
	' (weight = ' num2str(obj.weights(i)) ')']);
  disp(c);
end
