function plot(obj, color)

if nargin < 2
  color = 'g';
end

a = obj.prediction_matrix(1, 1);
b = obj.offset(1);
s = sqrt(obj.cov(1, 1));

v = axis;
res = 50;
yrange = v(4) - v(3) + 1;
xrange = v(2) - v(1) + 1;
r = v(1):(xrange/res):v(2);
dash = ['--' color];
plot(r, a*r + b, color, r, a*r + b + s, dash, r, a*r + b - s, dash);
%plot(r, a*r + b, color)
