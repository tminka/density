function obj = trainBegin(obj)

% estimation proceeds like joint Gaussian estimation
d = rows(obj.prediction_matrix) + cols(obj.prediction_matrix);
obj.temp_mean = zeros(d, 1);
obj.temp_cov = zeros(d);
obj.n = 0;
