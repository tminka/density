function p = is_exponential(data)
% IS_EXPONENTIAL(data) returns the log-probability that data comes from some
% Exponential distribution.

n = cols(data);
p = gammaln(n) - n * log(sum(data));
