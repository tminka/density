function plot(obj, varargin)

for i = 1:length(obj.weights)
  c = obj.components{i};
  plot(c, varargin{:});
  hold on
end
hold off
