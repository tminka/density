function obj = trainBegin(obj)

obj.temp_weights = zeros(length(obj.weights), 1);
obj.n = 0;

for i = 1:length(obj.weights)
  c = obj.components{i};
  if obj.train_components
    %c = set_phase(c, obj.phase);
    obj.components{i} = trainBegin(c);
  end
end

% the temperature could be set here based on the phase.
%obj.temperature = 10/(obj.phase+1);
