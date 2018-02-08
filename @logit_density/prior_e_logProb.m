function p = prior_e_logProb(obj, es)

for i = 1:cols(es)
  obj.e = es(:, i);
  s = 1 ./ (1 + exp(-obj.theta' * obj.data));
  u = (0.5 - s) .^ 2;
  pp = (exp(logProb(obj, obj.data)) + 1e-4);
  pp = pp .* (1 - exp(logProb(obj, obj.data)) + 1e-4);
  he = sum(u ./ pp);
  p(i) = 0.5*log(he);
end
