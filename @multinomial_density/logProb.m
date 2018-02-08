function p = logProb(obj, x)
% each column of x is a histogram

p = col_sum(x .* repmat(log(obj.p+eps), 1, cols(x)));
