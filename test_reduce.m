% Mixture reduction techniques

% The mixture
norm1 = normal_density(3, 1);
norm2 = normal_density(5.5, 2);
w = [0.4 0.6];
mix = mixture_density(w, norm1, norm2);
figure(1);
axis([0 8 0 1]);
plot(mix, 'g');
% print -dps2 mixture.ps

% Gaussian maximizing cross-entropy
obj1 = normal_density(get_mean(mix), get_cov(mix));
disp(obj1);
draw(obj1, 'b--');

% cross-entropy to each component
ms = 2:0.05:6.5;
v = 2;
ce1 = [];
ce2 = [];
for mi = 1:length(ms)
  obj = normal_density(ms(mi), v);
  ce1(mi) = cross_entropy(norm1, obj);
  ce2(mi) = cross_entropy(norm2, obj);
end
[ce,mi] = max(ce1*w(1) + ce2*w(2));
ms(mi)
figure(2);
plot(ms, ce1, ms, ce2, ms, ce1*w(1) + ce2*w(2), '--')
axis([2 6.5 -5 -1]);
line([ms(mi) ms(mi)], [-5 -1], 'Color', 'black');
xlabel('mean of approximator')
ylabel('cross-entropy')
% print -dps2 ce_component.ps

if 0
% Gaussian minimizing reversed KL-divergence
m = 4.5;

vs = 2.35:0.01:4;
e = [];
g = [];
for vi = 1:length(vs)
  v = vs(vi);
  obj = normal_density(m, v);
  [h, hm, hv] = cross_entropy(obj, mix);
  e(vi) = cross_entropy(obj, obj) - h;
  g(vi) = inv(v) * ((1 - h) + (hv - 2*hm*m' + h*m*m')*inv(v));
  %g(vi) = v * (1 - h) + (hv - 2*hm*m' + h*m*m');
end
[gm, vi] = min(abs(g));
vs(vi)
figure(4)
plot(vs, g);
line([0 4], [0 0], 'Color', 'black');
figure(3)
plot(vs, e);
return
end

% minimum is m = 4.4782, v = 2.3636
m = 4.5;
v = 2.353;
step = 0.5;
e = [];
for i = 1:50
  obj = normal_density(m, v);
  [h, hm, hv] = cross_entropy(obj, mix);

  if 0
    % fixed point update
    % doesn't work - goes to wrong fixed point
    %m = hm / h
    v = (hv - 2*hm*m' + h*m*m') / (h + 1);
  else
    % gradient descent
    m = m + step/v * (hm - m*h)
    %v = 1/(1/v - step/10 * (v * (1 - h) + (hv - 2*hm*m' + h*m*m')));
    v = v + step/10 * inv(v) * ((1 - h) + (hv - 2*hm*m' + h*m*m')*inv(v))
  end
  
  e(i) = cross_entropy(obj, obj) - cross_entropy(obj, mix);
  if abs(e(i) - 1.6501) < 1e-4
    v
  end
  figure(3);
  plot(e);
  drawnow
end
obj2 = normal_density(m, v);
disp(obj2);
figure(1);
draw(obj2, 'r-.');

% Minimizing a bound on reversed KL-divergence
m = 4;
v = 2;
e = [];
b = [];
c = get_components(mix);
w = get_weights(mix);
for j = 1:length(c)
  ivc(:, j) = inv(get_cov(c{j}));
  mc(:, j) = get_mean(c{j});
end
for i = 1:20
  obj = normal_density(m, v);

  % E-step
  for j = 1:length(c)
    a(j) = cross_entropy(obj, c{j}) + log(w(j));
  end
  a = exp(a - logSum(a));

  % M-step
  if 1
    % fixed point update
    v = inv(ivc * a');
    m = v * (ivc .* mc * a');
  else
    % gradient descent
    m = m + step * ivc .* (mc - repeatcol(m, cols(mc))) * a';
    v = v - step/5 * (-inv(v) + ivc * a')
  end

  e(i) = cross_entropy(obj, obj) - cross_entropy(obj, mix);
  b(i) = cross_entropy(obj, obj);
  for j = 1:length(c)
    b(i) = b(i) - (cross_entropy(obj, c{j}) + log(w(j)) - log(a(j))) * a(j);
  end
  figure(3);
  plot(1:i, e, 1:i, b, '--');
  xlabel('Iteration number');
  ylabel('KL-divergence');
  % print -dps2 kl_bound.ps
  drawnow
end
obj3 = normal_density(m, v);
disp(obj3);
figure(1);
draw(obj3, 'k:');
