function [obj, activity] = trainEnd(obj)

activity = 0;

if obj.train_components
  for i = 1:length(obj.weights)
    c = obj.components{i};
    [obj.components{i},activity_i] = trainEnd(c);
		activity = max(activity, activity_i);
  end
end

if obj.train_weights && obj.phase > 2
  old_weights = obj.weights;
  a = get_a(obj.weights_prior);
  obj.weights = (obj.temp_weights + a - 1) / (obj.n + sum(a) - length(a));
  activity = max(activity, max(abs(obj.weights - old_weights)));
end

if 0
  figure(1)
  %delete(findobj('Tag', 'mixture_density', 'Color', [1 0 0]))
  delete(findobj('Tag', 'mixture_density'))
  draw(obj, 'r');
end
