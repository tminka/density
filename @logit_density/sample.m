function x = sample(obj, n)
% Return n samples from the density.

if nargin < 2
  n = 1;
end

% sample from a 1-d logistic
a = norm(obj.theta);
x = logit_sample(a, n);

% rotate (theta/a == pinv(theta'))
x = obj.theta/a * x;

% add noise orthogonal to theta
x = x + null(obj.theta') * randn(1, n) / 2;
