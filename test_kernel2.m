if 1
  mix = mixture_density([1 1], normal_density([0;0], 0.5*eye(2)), ...
      normal_density([4;4], eye(2)));
  data = sample(mix, 100);
else
  load /tilde/tminka/src/clustering/data/rings.pts
  data = rings';
end

obj = kernel_density; %(20);
obj = train(obj, data);
%disp(obj);

figure(1)
plot(data(1, :), data(2, :), '.');
draw(obj);
v = axis;

figure(3);
axis(v);
density_image(obj);

logProb(obj, data)
logProb_indata(obj, data)
