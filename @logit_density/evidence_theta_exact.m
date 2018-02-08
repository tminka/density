function e = evidence_theta_exact(obj, data)

% determine range of integration
v = get_theta(obj);
h = max(abs(v));
r1 = v - 3*h;
r2 = v + 3*h;
d = length(v);
if d == 2
  inc = (r2-r1)/50;
else
  inc = (r2-r1)/20;
end

vs = lattice([r1 inc r2]);
z = zeros(cols(vs),1);
for i = 1:cols(vs)
  obj.theta = vs(:,i);
  z(i) = sum(logProb(obj, data));
end
z = z + prior_theta_logProb(obj, vs)';
e = logSum(z) + sum(log(inc));
