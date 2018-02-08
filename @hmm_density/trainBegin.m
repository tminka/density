function obj = trainBegin(obj)

obj.temp_weights = zeros(size(obj.weights));
obj.temp_transitions = zeros(size(obj.transitions));
obj.n = 0;

for i = 1:length(obj.weights)
  c = obj.components{i};
  c = set_phase(c, obj.phase);
  obj.components{i} = trainBegin(c);
end
