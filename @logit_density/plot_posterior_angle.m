function plot_posterior_angle(obj, data, z)

theta = obj.theta;

angles = -pi:0.01:pi;
%angles = -pi:0.01:-1;
if nargin < 3
  z = norm(obj.theta);
  disp(['norm = ' num2str(z)])
end
e = [];
for i = 1:length(angles)
  obj.theta(1) = cos(angles(i))*z;
  obj.theta(2) = sin(angles(i))*z;
  %obj.theta = expm(-skew(angles(i)))*z;
  %obj.theta = obj.theta(:,1);
  e(i) = sum(logProb(obj, data));
  %e(i) = prior_theta_logProb(obj, obj.theta);
end
%e = exp(e);
plot(angles, e)

if 1
  [emax,i] = max(e);
  disp(['best angle = ' num2str(angles(i))])
end

if 1
  % plot the current parameters on top of the posterior
  obj.theta = theta/norm(theta)*z;
  p = sum(logProb(obj, data));
  %p = p + prior_theta_logProb(obj, theta);
  %p = exp(p);
  hold on
  angle = atan2(theta(2), theta(1));
  disp(['actual angle = ' num2str(angle)])
  plot(angle, p, 'gx');
  hold off
end

obj.theta = theta;
