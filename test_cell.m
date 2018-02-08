c = cell(1, 2);
c{1} = normal_density(0, 1);
c{2} = wishart_density(eye(2), 5, 'inverse');
obj = cell_density(c);
disp(obj)

data = sample(obj)
logProb(obj, data)
