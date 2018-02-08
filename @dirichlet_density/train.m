function obj = train(obj, data, bar_p)
% data is a matrix of columns
% each column is a probability vector

show_progress = 0;

a = obj.a;

% initialize
%a = moment_match(obj, data);

% sufficient statistics
if nargin < 3
  bar_p = moment1(log(data));
end
if 0
  w = ones(size(a));
  w = (1:length(a))';
  w = [1 0 0 0]';
  w = w / sum(w)
  slr = bar_p - sum(w.*bar_p)
end

if 0
  % Newton's method
  % not stable
  for iter = 1:100
    old_a = a;
    f = digamma(sum(a)) - digamma(a) + bar_p;
    e(iter) = gammaln(sum(a)) - sum(gammaln(a)) + sum(bar_p.*a);
    g = trigamma(sum(a)) - trigamma(a);
    a = a - f./g;
    a(find(a < 0)) = eps;
    if norm(a - old_a) < 1e-5
      break
    end
  end
  figure(3)
  plot(e)
end

if 1
  % alternate betw train_mean and train_var
  % this is most stable
  s = sum(obj.a);
  if s <= 0
    % bad initial guess; fix it
    disp('fixing initial guess')
    if s == 0
      obj.a = ones(size(obj.a))/length(obj.a);
    else
      obj.a = obj.a/s;
    end
    s = 1;
  end
  while(1)
    old_s = s;
    obj = train_mean(obj, data, bar_p);
    m = obj.a/s;
    obj = train_var(obj, data, bar_p);
    s = sum(obj.a);
    if abs(s - old_s) < 1e-4
      break
    end
  end
  return
end

obj.a = a;

if 0
  % plot the likelihood
  inc = 0.1;
  r = inc:inc:3;
  as = lattice([r(1) inc r(length(r)); r(1) inc r(length(r))]);
  e = [];
  for i = 1:cols(as)
    obj.a = as(:,i);
    like(i) = sum(logProb(obj, data))/cols(data)*2;
    a = as(:,i);
    g = digamma(a) - sum(digamma(a))/length(a);
    e(i) = sum(abs(g - slr));
    if e(i) > 1
      e(i) = 1;
    end
  end
  like = like - max(like);
  like = reshape(like, length(r), length(r));
  e = reshape(e, length(r), length(r));
  figure(2)
  mesh(r, r, exp(like));
  rotate3d on
  figure(3)
  clf
  mesh(r, r, e)
  rotate3d on
  hold on
  plot3(step(1,:),step(2,:),ones(1,cols(step))*0.5,'-')
  axis([r(1) r(length(r)) r(1) r(length(r)) 0 1])
end
