function p = evidence(obj, data)

if strcmp(obj.e_type, 'fixed')
  p = evidence_theta(obj, data);
  return
end

% double integral over e and theta
inc = 0.01;
r = 0:inc:1;
obj.e_type = 'fixed';
for i = 1:length(r)
  obj.e = r(i);
  % evidence_theta only works for trained parameters
  obj = train(obj, data);
  z(i) = exp(evidence_theta(obj, data));

  figure(6);
  plot(r(1:i), z(1:i));
end
p = sum(z)*inc;
