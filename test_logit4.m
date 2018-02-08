% show max-margin behavior

% [x,y] = ginput(4)
% data1 = [x y]';
% data2 = [x y]';

if 1
  m1 = [0;10];
  data1 = randnorm(3, m1, [], eye(2)/10);
  x = [0;0];
  data1 = [data1 x];
  x = [2;12];
  data1 = [data1 x];
  plot(data1(1,:), data1(2,:), 'o')
  
  m2 = [10;0];
  data2 = randnorm(3, m2, [], eye(2)/10);
  x = [10;10];
  data2 = [data2 x];
  x = [8;-2];
  data2 = [data2 x];

  data1 = [data1 randnorm(1000, m1, [], eye(2)/10)];
  data2 = [data2 randnorm(1000, m2, [], eye(2)/10)];
  
end

data = [ones(1,cols(data1)) -ones(1,cols(data2)); data1 -data2];

obj = logit_density(ones(rows(data), 1)/10, 0);
obj.e_type = 'fixed';
obj = train(obj, data);
figure(1)
plot(data1(1,:), data1(2,:), 'o', data2(1,:), data2(2,:), 'x')
draw(obj,'g')
