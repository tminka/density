function obj = lls_density(prediction_matrix, cov, offset)
% LLS_DENSITY   Linear least-squares regression.
%    LLS_DENSITY(prediction_matrix, cov, offset).
%    y = prediction_matrix * x + N(offset, cov)
%    prediction_matrix need not be square.
%    Requires rows(offset) = rows(cov) = rows(transition_matrix).
%    offset defaults to 0.

[d,m] = size(prediction_matrix);
if nargin < 3
  offset = zeros(d, 1);
end
% Noninformative prior
prior = 'none';
%prior = normal_wishart_density(zeros(d,m), zeros(m), zeros(d), 0);

% obj.n is the number of samples used to train the density.
% This is useful for computing posterior distributions.
s = struct('prediction_matrix', prediction_matrix, 'cov', cov, ...
           'cov_type', '', 'temp_mean', [], 'temp_cov', [], ...
	   'mx', [], 'my', [], 'sxx', [], 'syx', [], 'syy', [], ...
           'offset', offset, 'offset_type', 'fixed', ...
	   'n', 0, 'prior', prior, 'alpha', 0, 'n0', 0);
obj = class(s, 'lls_density');
