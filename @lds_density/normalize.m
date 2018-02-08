function obj = normalize(obj)
% Rescale the parameters so that norm(obj.emission_matrix) = 1.
% If obj.emission_matrix is square, make it the identity.

emission_matrix = get_prediction_matrix(obj.emission_density);
if rows(emission_matrix) == cols(emission_matrix)
  z = emission_matrix;
else
  z = norm(emission_matrix);
end
obj.emission_density = set_prediction_matrix(obj.emission_density, ...
    emission_matrix / z);
obj.prior_state = scale(obj.prior_state, z);
obj.transition_density = scale(obj.transition_density, z);
