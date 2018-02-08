function s = logSub(a, b)
% Returns log(exp(a) - exp(b)) while avoiding numerical underflow.

s = -Inf*ones(size(a));
i = find(a > b+eps);
s(i) = a(i) + log(1 - exp(b(i)-a(i)));
i = find(a < b-eps);
s(i) = NaN;
