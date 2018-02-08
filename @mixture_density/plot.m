function h = plot(obj, varargin)

if length(varargin) < 1
  color = 'g';
else
  color = varargin{1};
end

if 1
  % plot the whole probability surface
  v = axis;
  yrange = v(4) - v(3);
  xrange = v(2) - v(1);
  res = 100;
  r = v(1):(xrange/res):v(2);
  p = exp(logProb(obj, r));
  %h = plot(r, p*yrange + v(3), color);
  h = plot(r, p, color);
  set(h, 'Tag', 'mixture_density');
else
  % plot each component separately
  colors = ['r' 'g' 'm' 'b' 'c' 'k'];
  for i = 1:length(obj.weights)
    c = obj.components{i};
    if obj.weights(i) > 0
      %h = plot(c, varargin{:});
      h = plot(c, colors(rem(i, length(colors))+1));
    else
      h = plot(c, 'k');
    end
    set(h, 'Tag', 'mixture_density');
    hold on
  end
  hold off
end
