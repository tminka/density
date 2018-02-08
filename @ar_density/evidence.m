function p = evidence(obj)
% Returns the log-probability of data under the prior,
% ignoring the current parameter values (the parameters are integrated out).
% The data used to train the parameters is used.

p = evidence(obj.prediction_density);
