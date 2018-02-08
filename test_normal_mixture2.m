means = [1 4];
means = [2 2.3];
cov = 0.5;
mix = normal_mixture_density(means, cov);
if 0
  data = sample(mix, 20);
end
figure(1)
plot(data, ones(1, length(data)), '.');
draw(mix);

if 1
  % plot the probability surface
  r1 = 0;
  r2 = 3;
  inc = (r2-r1)/20;
  r = r1:inc:r2;
  x = lattice([r1 inc r2; r1 inc r2]);
  p = [];
  for i = 1:cols(x)
    if 1
      means = x(:,i)';
    else
      a = x(1,i);
      b = x(2,i);
      means = [(a+b) (a-b)];
    end
    obj = normal_mixture_density(means, cov);
    p(i) = sum(logProb(obj, data));
  end
  s = length(r);
  p = reshape(p, s, s);
  p = exp(p);
  figure(2);
  if 1
    mesh(r, r, p);
    rotate3d on;
    axis tight
  else
    colormap('bone')
    imagesc(r, r, p);
  end
  [y,j] = max(p);
  [x,i] = max(y);
  [r(i) r(j(i))]

  figure(5);
  plot(r, sum(p')*inc);
end

if 1
  obj = train(mix, data);
  disp(obj)
  e = sum(sum(p))*inc*inc
  exp(evidence(obj, data))
  % when components are far apart, we are 2x smaller (EM approx is similar)
  % when components are close, we are about right
  % when components are identical, we are 2x bigger, since Gaussian approx
  %   breaks down. (and the EM approx is way too small)
end

if 0
  post = get_posterior(obj, data);
  figure(4);
  plot(post, 'mesh', r, exp(evidence(obj, data)));
end
