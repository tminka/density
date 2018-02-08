if 1
  mix = mixture_density([1 1], normal_density([0;0], 0.5*eye(2)), ...
      normal_density([4;4], eye(2)));
  data = sample(mix, 20);
else
  load /tilde/tminka/src/clustering/data/rings.pts
  data = shuffle(rings)';
end

if 0
  k1 = kernel_density(40);
  k1 = train(k1, data(:, 1:(length(data)/2)));
  k2 = kernel_density(40);
  k2 = train(k2, data(:, (length(data)/2+1):length(data)));
  cs = {k1 k2};
else
  % separate class for each point
  cs = cell(cols(data), 1);
  for i = 1:cols(data)
    c = kernel_density(10);
    c = train(c, data(:, i));
    cs{i} = c;
  end
end
obj = mixture_density(ones(length(cs), 1), cs{:});
figure(1)
clf
obj = train(obj, data);

figure(1)
plot(data(1, :), data(2, :), '.');
draw(obj);
v = axis;

figure(3);
axis(v);
density_image(obj);
