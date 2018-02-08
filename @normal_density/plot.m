function h = plot(obj, color, r, v)

if nargin < 2
  color = 'g';
end

if rows(obj.mean) > 1
  if color == 'mesh'
    [x,y] = meshgrid(r, r);
    x = [vec(x) vec(y)]';
    z = exp(logProb(obj, x));
    z = reshape(z, length(r), length(r));
    h = mesh(r, r, z);
    view(0, 85);
    rotate3d on;
    colormap('hsv');
    axis tight;
    set(h, 'Tag', 'normal_density');
  else
    h = plot(obj.mean(1, :), obj.mean(2, :), ['x' color]);
    set(h, 'Tag', 'normal_density');
    h = draw_ellipse(obj.mean(1:2), obj.cov(1:2, 1:2), color);
    set(h, 'Tag', 'normal_density');
    % need to combine both h's into one handle
  end
else
  if nargin < 3
    v = axis;
    res = 100;
    yrange = v(4) - v(3);
    xrange = v(2) - v(1);
    r = v(1):(xrange/res):v(2);
  end
  p = exp(logProb(obj, r));
  yrange = 1000;
  h = plot(r, p*yrange + v(3), color);
  %h = plot(r, p, color);
  set(h, 'Tag', 'normal_density');
end
