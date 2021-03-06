function p = evidence(obj, data)
% Returns the log-probability of data under the prior,
% ignoring the current parameter values (the parameters are integrated out).

if isa(data, 'cell')
  data = data{:};
end

n = cols(data);
% normalizing term
a = get_a(obj.prior);
s = sum(a);
p = gammaln(s) - gammaln(n + s);

counts = int_hist(data, length(obj.p));
counts = counts(:);
p = p + sum(gammaln(counts + a)) - sum(gammaln(a));
