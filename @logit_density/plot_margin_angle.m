function plot_margin_angle(obj, x)

angles = -pi:0.01:pi;
%angles = -pi:0.01:-1;
e = [];
theta = obj.theta;
for i = 1:length(angles)
  theta(1) = cos(angles(i));
  theta(2) = sin(angles(i));
  %theta = expm(-skew(angles(i)));
  %theta = theta(:,1);
  e(i) = min(theta'*x);
end
plot(angles, e)

[emax,i] = max(e);
disp(['min margin = ' num2str(angles(i))])
%abs(e(i) - e(i+1))
