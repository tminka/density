if ~exist('setrep')
  path(path, '/u/tpminka/matlab/setrep')
end

means = [0 2; 0 3]/10;
cov = [1 1; 1 2];
cov = eye(2);
mix = normal_mixture_density(means, cov);
disp(mix)
if 0
  data = sample(mix, 10);
end
figure(1);
plot(data(1, :), data(2, :), '.');
draw(mix);

obj = normal_mixture_density(rand(2, 2), eye(2));
obj = train(obj, data);
disp(obj);

exp(evidence(obj, data))
% answer is 2.3679e-11

if 1
  % compute the evidence by brute force
  r1 = -2;
  r2 = 2;
  inc = (r2-r1)/5;
  r = r1:inc:r2;
  x = lattice([r1 inc r2; r1 inc r2; r1 inc r2; r1 inc r2]);
  if 0
    y = [];
    for i = 1:cols(x)
      v = vtrans(x(:, i), 2);
      rep = setrep(v);
      y(:,i) = rep(:);
    end
    return
  end
  p = [];
  cols(x)
  for i = 1:cols(x)
    if rem(i, 1000) == 1
      i
    end
    means = vtrans(x(:,i), 2);
    if 0
      obj = normal_mixture_density(means, eye(2));
      p(i) = exp(sum(logProb(obj, data)));
    else
      means(:,1) = means(:,1)/2;
      p(i) = exp(-sum(sum(means.^2)));
    end
  end
  sum(p)*inc^4
  % answer is  2.8785e-11
  plot(p)
  drawnow
end

if 1
  % compute the evidence by brute force in setrep parameterization
  r1 = -2;
  r2 = 2;
  inc = (r2-r1)/5;
  r = r1:inc:r2;
  x = lattice([r1 inc r2; r1 inc r2; r1 inc r2; r1 inc r2]);
  if 0
    y = [];
    for i = 1:cols(x)
      v = vtrans(x(:, i), 2);
      rep = inv_setrep(v);
      y(:,i) = rep(:);
    end
    return
  end
  p = [];
  cols(x)
  for i = 1:cols(x)
    if rem(i, 1000) == 1
      i
    end
    means = vtrans(x(:,i), 2);
    means = inv_setrep(means);
    if 0
      obj = normal_mixture_density(means, eye(2));
      p(i) = exp(sum(logProb(obj, data)));
    else
      means(:,1) = means(:,1)/2;
      p(i) = exp(-sum(sum(means.^2)));
    end
  end
  sum(p)*inc^4'
  % answer is  2.9468e-11
  plot(p)
  drawnow
end

if 0
  exp(evidence(obj, data, 'sampling'))
  % answer is 2.8852e-11
end

if 0
  js = [1 2 3 4 5 6];
  for i = 1:length(js)
    j = js(i);
    
    obj = normal_mixture_density(rand(2, j), eye(2));
    obj = train(obj, data);
    e(i) = evidence(obj, data);
    figure(5);
    plot(js(1:i), e(1:i));
    
    p(i) = sum(logProb(obj, data));
    figure(4);
    plot(js(1:i), p(1:i));
  end
end

if 0
  vs = 0.2:0.2:2;
  vs = fliplr(vs);
  for i = 1:length(vs)
    v = vs(i);
    
    if i == 1
      obj = normal_mixture_density(rand(2, 4), eye(2)*v);
    else
      obj = set_cov(obj, eye(2)*v);
    end
    obj = train(obj, data);
    e(i) = evidence(obj, data);
    figure(5);
    plot(vs(1:i), e(1:i));
    
    p(i) = sum(logProb(obj, data));
    figure(4);
    plot(vs(1:i), p(1:i));
  end
end
