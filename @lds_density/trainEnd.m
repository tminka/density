function obj = trainEnd(obj)

if obj.train_emission
  obj.emission_density = trainEnd(obj.emission_density);
end

% always update covariances slower than means
if obj.phase > 1
  %obj.emission_cov = obj.temp_emission_cov / obj.n;
end

%if obj.phase > 2
  obj.transition_density = trainEnd(obj.transition_density);
%end

if obj.phase > 3
  %obj.transition_cov = obj.temp_transition_cov / obj.n;
  if obj.train_prior_state
    obj.prior_state = trainEnd(obj.prior_state);
  end
end

obj = normalize(obj);
