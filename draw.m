function h = draw(obj, varargin)
% 'draw' means 'plot' on the current plot.

hold on
if 0
  % drawnow is needed to set the axes before "axis manual"
  drawnow
  axis manual
end
if nargout == 0
  plot(obj, varargin{:});
else
  h = plot(obj, varargin{:});
end
hold off
