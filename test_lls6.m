% finding the right model
% construction project example on p.201,223,276 of Bowerman/O'Connell

if 1
  load('data/construction');
  data = construction';
end
figure(1);
plot(data(1, :), data(3, :), 'o');
xlabel('Contract Size (100k)');
ylabel('Profit');
figure(2)
plot(data(2, :), data(3, :), 'o');
xlabel('Supervisor experience (years)');
ylabel('Profit');

vars = [];
vars(1:2, :) = data(1:2,:).^2;
vars(3, :) = data(1,:) .* data(2,:);
vars(4, :) = data(1,:) .* vars(3,:);

% book prefers [1 0 1 1], and so does evidence

r = {};
for i = 1:rows(vars)
  r{i} = [0 1];
end
b = ndgridmat(r{:});
e = [];
for i = 1:rows(b)
  c = b(i,:);
  data2 = [vars(find(c), :); data];
  obj = lls_density(ones(1, rows(data2)-1), 1);
  if 0
    % evidence normalization doesn't work here since there are too few points
    % but then the evidence is sensitive to scaling the original data
    data1 = data2(:,1:8);
    obj1 = train(obj, data1);
    e1 = evidence(obj1);
  end
  obj = train(obj, data2);
  e(i) = evidence(obj);
end
figure(3);
plot(1:length(e), e);
xlabel('Feature set')
ylabel('Evidence')
i = argmax(e);
fprintf('Best feature set:')
c = b(i,:);
disp(c)
