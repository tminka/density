maxk = 100;
class1 = multinomial_density(rand(1, maxk));
class2 = multinomial_density(rand(1, maxk));

if 0
n = 10;
data = cell(1, 2);
data{1} = sample(class1, n);
data{2} = sample(class2, n);

% group size
gn = 5;
test = cell(1, 3*2);
for i = 1:(length(test)/2)
  test{2*i-1} = sample(class1, gn);
  test{2*i} = sample(class2, gn);
end
end

% class priors
obj = multinomial_density(ones(1, maxk));
for j = 1:2
  obj = train(obj, data{j});
  prior{j} = get_posterior(obj);
  post{j} = posterior_predict(obj);
  %e{j} = evidence(obj, data{j});
end

% independent classification
% if n is large, this is same as brute force, regardless of gn
mix = mixture_density([0.5 0.5], post{:});
mbr = classify(mix, test);
[y, ci] = max(mbr);
ci
% this is conditional evidence since the mixture already incorporates the
% training data
class_evidence(mix, test, ci)

beta = 0.1;
count = class_counts(test, maxk, ci, 2);
count = class_counts(test, maxk, [1 2 2 2 2 1], 2);
count = count * beta;
a = [];
for j = 1:2
  a(:,j) = get_a(prior{j})';
end
elp = digamma(count+a) - repmat(digamma(sum(count+a)), rows(count), 1);

if 1
% brute force classification
cs = lattice(repmat([1 1 2], cols(test), 1));
p = [];
q = [];
for i = 1:cols(cs)
  c = cs(:,i);
  p(i) = class_evidence(mix, test, c);
  
  % lower bound
  q(i) = 0;
  for m = 1:length(c)
    icount = hist_int(test{m}, maxk)';
    q(i) = q(i) + sum(icount .* elp(:, c(m)));
  end
end
q = q - sum(sum(count .* elp));
q = q + sum(gammaln(sum(a))) - sum(sum(gammaln(a)));
q = q - sum(gammaln(sum(count+a))) + sum(sum(gammaln(count+a)));
figure(4)
plot(1:cols(cs), p, 1:cols(cs), q)
[y,i] = max(p);
cb = cs(:,i)'
y
end
return

if 1
% EM classification
% if gn is large, this is more similar to brute force
% though it is not always identical
% sometimes it can consistently give the wrong answer
if 1
  % perturb the predictions slightly
  q = get_p(post{1}) + rand/100/maxk;
  q = q/sum(q);
  post{1} = set_p(post{1}, q);
end
mix = mixture_density([0.5 0.5], post{:});
mix = train(mix, test);
mbr = classify(mix, test);
[y, ce] = max(mbr);
ce
class_evidence(mix, test, ce)
end

% Reverse EM classification
% requires good initialization
% sampling from the independent classification distribution might give
% good starting points
c = ci;
%c = (rand(1, length(c)) < 0.5) + 1;
c
e = class_evidence(mix, test, c);
oldc = c;
olde = e;
% annealing loop
for beta = 0:0.1:1
  for iter = 1:5
    % E-step
    count = class_counts(test, maxk, c, 2);
    count = count * beta;
    elp = digamma(count+a) - repmat(digamma(sum(count+a)), rows(count), 1);
    
    % M-step
    p = [];
    for i = 1:length(c)
      icount = hist_int(test{i}, maxk)';
      p(i,:) = sum(repmat(icount, 1, cols(count)) .* elp);
    end
    [y, c] = max(p');
    e = class_evidence(mix, test, c);
    if all(c == oldc) | (e < olde)
      break
    end
    oldc = c;
    olde = e;
    c
  end
end
olde

