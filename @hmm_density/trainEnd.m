function obj = trainEnd(obj)

obj.weights = obj.temp_weights / obj.n;
if obj.phase > 2
  % In the first phase, the data is simply clustered.
  % Later the transition structure is learned.
  obj.transitions = obj.temp_transitions / obj.n;
end

for i = 1:length(obj.weights)
  c = obj.components{i};
  obj.components{i} = trainEnd(c);
end

if 1
  figure(1)
  delete(findobj('Tag', 'normal_density', 'Color', [1 0 0]));
  delete(findobj('Tag', 'normal_density', 'Color', [0 0 0]));
  draw(obj, 'r');
end
