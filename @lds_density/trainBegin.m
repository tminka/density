function obj = trainBegin(obj)

obj.transition_density = trainBegin(obj.transition_density);
if obj.train_emission
  obj.emission_density = trainBegin(obj.emission_density);
end
if obj.train_prior_state
  obj.prior_state = trainBegin(obj.prior_state);
end
obj.n = 0;
