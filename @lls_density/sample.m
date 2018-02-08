function y = sample(obj, x)
% Sample an output for each column of x.
% rows(y) = rows(obj.prediction_matrix).
% cols(y) = cols(x).

y = randnorm(cols(x), obj.offset, [], obj.cov);
y = y + obj.prediction_matrix * x;
