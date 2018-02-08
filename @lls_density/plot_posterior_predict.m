function plot_posterior_predict(obj, color, xs, zs)

if nargin < 2
  color = 'g';
end
style1 = ['--' color];
style2 = ['-.' color];

color = 'b';
style1 = 'g';
style2 = 'r';

v = axis;
yrange = v(4) - v(3) + 1;
xrange = v(2) - v(1) + 1;
res = 50;
xinc = xrange/res;
yinc = yrange/res;
if nargin < 3
  xs = v(1):xinc:v(2);
end
if nargin < 4
  zs = xs;
end
ic = 1 + col_sum(xs.*(inv(obj.sxx)*xs));
s = sqrt(obj.cov*ic);

ys = obj.prediction_matrix*xs + obj.offset;
plot(zs, ys, color, zs, ys + s, style1, zs, ys - s, style1, ...
    zs, ys + 2*s, style2, zs, ys - 2*s, style2);

if 0
  ys = v(3):yinc:v(4);
  diff = repmat(ys', 1, length(xs)) - repmat(obj.prediction_matrix*xs, length(ys), 1);
  if 0
    e = (diff.^2) ./ repmat(ic, length(ys), 1);
    e = e/obj.cov;
    %e = e + repmat((2*pi*obj.cov).*ic, length(ys), 1);
    e = (-1/2)*e;
    e = e - max(max(e));
    e = exp(e);
  else
    ic = sqrt(obj.cov*ic);
    e = abs(diff) ./ repmat(ic, length(ys), 1);
  end
  if nargin < 4
    zs = xs;
  end
  if 0
    contour(zs, ys, e, [1 2], '--');
    hold on
    plot(zs, obj.prediction_matrix*xs, color);
    hold off
  else
    mesh(zs, ys, e);
    rotate3d on
  end
  return
end

