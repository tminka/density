function gauss = asGaussian(obj, n)
% Returns the equivalent Gaussian density for a sequence of length n.

A = get_prediction_matrix(obj.transition_density);
input = get_offset(obj.transition_density);
Gamma = get_cov(obj.transition_density);
C = get_prediction_matrix(obj.emission_density);
offset = get_offset(obj.emission_density);
Sigma = get_cov(obj.emission_density);

Cn = kron(eye(n), C);

% compute the mean of the state variables
sm = [];
s = get_mean(obj.prior_state);
for i = 1:n
  sm(:, i) = s;
  s = A*s + input;
end
sm = sm(:);
% mean of the output
m = kron(ones(n, 1), offset) + Cn*sm;

% compute the covariance of the state variables
An = kron(diag(ones(1, n-1), -1), A);
An = pinv(eye(size(An)) - An);
v1 = get_cov(obj.prior_state);
Gn = directsum(v1, kron(eye(n-1), Gamma));
sv = An*Gn*An';
% covariance of the output
v = Cn*sv*Cn' + kron(eye(n), Sigma);

gauss = normal_density(m, v);
