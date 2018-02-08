function plot(obj, type)

if nargin < 2
  type = 'mesh';
end

v = axis;
x1 = v(1);
x2 = v(2);
xinc = (x2-x1)/50;
r1 = x1:xinc:x2;
y1 = v(3);
y2 = v(4);
yinc = (y2-y1)/50;
r2 = y1:yinc:y2;
x = lattice([x1 xinc x2; y1 yinc y2]);
p = logProb(obj, x);
p = exp(reshape(p, length(r1), length(r2)));
if strcmp(type, 'contour')
  contour(r1, r2, p, 5);
else
  mesh(r1, r2, p);
  axis tight;
  rotate3d on;
end
%sum(sum(p))*xinc*yinc
