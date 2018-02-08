function obj = lds_density(transition_matrix, transition_cov, ...
                           prior_mean, prior_cov, ...
			   emission_matrix, emission_cov, ...
			   emission_mean, transition_mean)
% LDS_DENSITY   Continuous-state linear dynamical system.
%    LDS_DENSITY(transition_matrix, transition_cov,
%                prior_mean, prior_cov,
%                emission_matrix, emission_cov)
%    returns a LDS with 
%      A = transition_matrix
%      Gamma = transition_cov
%      C = emission_matrix
%      Sigma = emission_cov

if nargin < 8
  transition_mean = zeros(rows(transition_matrix), 1);
end
if nargin < 7
  emission_mean = zeros(rows(emission_matrix), 1);
end
emission_density = lls_density(emission_matrix, emission_cov, emission_mean);
transition_density = lls_density(transition_matrix, transition_cov, transition_mean);
s = struct('transition_density', transition_density, ...
	   'prior_state', normal_density(prior_mean, prior_cov), ...
	   'emission_density', emission_density, ...
	   'n', 0);
obj = class(s, 'lds_density');

obj.train_prior_state = 1;
obj.train_emission = 1;
