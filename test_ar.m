use_aux = 0;
if use_aux
  k = 2;
else
  k = 2;
end
if use_aux
  initial_density = normal_density(ones(k,1), eye(k)/100);
  obj = ar_density(k, lls_density([-1 1.9], 1e-3), initial_density, 1);
else
  initial_density = normal_density(zeros(k,1), eye(k));
  prediction_density = lls_density([-1 1.5], 1e-1);
  prediction_density = set_offset_type(prediction_density, 'fixed');
  %prediction_density = set_cov_type(prediction_density, 'fixed');
  obj = ar_density(k, prediction_density, initial_density);
end  
disp(obj)

if 1
  if use_aux
    n = 200;
    aux = zeros(1, n);
    aux(1:50:n) = 1;
    data = sample(obj, aux);
  else
    data = sample(obj, 200);
  end
else
  load /u/tpminka/6.343/hw2.mat
  data = speech1;
  data = data ./ 10000;
  if use_aux
    n = length(data);
    aux = zeros(1, n);
    aux(11:64:n) = 1;
  end
end
figure(1)
if use_aux
  plot(1:n, data, 1:n, aux);
else
  plot(data);
end
axis tight;

if use_aux
  data = [aux; data];
end
logProb(obj, {data})
obj = train(obj, {data});
logProb(obj, {data})
disp(obj)
return

% plot the posterior density using rc2poly
inc = 1/10;
x = lattice([-1.5 inc -0.5; 1.5 inc 2.5]);
p = [];
for i = 1:cols(x)
  obj = ar_density(k, lls_density(x(:,i)', 0.1), initial_density);
  p(i) = logProb(obj, {data});
  p(i) = (p(i) + logProb(obj, {fliplr(data)}))/10;
end
p = exp(p);
r1 = -1.5:inc:-0.5;
r2 = 1.5:inc:2.5;
p = reshape(p, length(r1), length(r2));
if 1
  [v,j] = max(p);
  [v,i] = max(v);
  r1(j(i))
  r2(i)
end
figure(3)
mesh(r1, r2, p);
axis tight;
rotate3d on;
return

% search for the right model order
ks = 1:15;
% use some of the data for evidence normalization
split = 2*max(ks)+1;
%split = cols(data)/2;
data1 = data(:, 1:split);

e = [];
for i = 1:length(ks)
  k = ks(i);
  initial_density = normal_density(zeros(k,1), eye(k));
  prediction_density = lls_density(ones(1,k), 1);
  prediction_density = set_offset_type(prediction_density, 'fixed');
  if use_aux
    obj = ar_density(k, prediction_density, initial_density, 1);
  else
    obj = ar_density(k, prediction_density, initial_density);
  end
  if 0
    obj1 = train(obj, {data1});
    e1 = evidence(obj1);
  else
    e1 = 0;
  end
  obj = train(obj, {data});
  e(i) = evidence(obj) - e1;
  figure(2)
  plot(ks(1:i), e(1:i));
end
