prototype = normal_density(0,1e-6);
means = 1:3;
corners = cell(1);
for i = 1:length(means)
  corners{i} = struct('mean', means(i));
end
weight_density = dirichlet_density([1/2 2 1/2]);
obj = simplicial_mixture_density(prototype, corners, weight_density);
disp(obj)

logProb(obj, [0 1 1.5 2])

figure(1)
axis([0 4 0 1])
plot(obj);
hold on
v = axis;
for i = 1:length(means)
  line([means(i) means(i)], [v(3) v(4)], 'Color', 'red', 'LineStyle', ':')
end
hold off
