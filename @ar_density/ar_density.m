function obj = ar_density(degree, prediction_density, initial_density, aux_matrix)
% AR_DENSITY   Linear autoregressive time-series model.
%   x(t) = prediction_matrix * [x(t-1); ...; x(t-degree)] + N(offset, cov) 
%            + aux_matrix * u(t-1)
%   where u(t) is optional auxiliary data.

if nargin > 3
  % append the aux_matrix to the prediction matrix
  p = get_prediction_matrix(prediction_density);
  prediction_density = lls_density([aux_matrix p], ...
      get_cov(prediction_density), get_offset(prediction_density));
  aux_dim = cols(aux_matrix);
else
  aux_dim = 0;
end

s = struct('degree', degree, 'prediction_density', prediction_density, ...
           'initial_density', initial_density, 'aux_dim', aux_dim);
obj = class(s, 'ar_density');
