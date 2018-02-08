function x = sample(obj, n)

if nargin < 2
  n = 1;
end

count = sample_hist(obj.p, n);
  
% expand the counts into samples
x = [];
for i = 1:length(count)
  if count(i) > 0
    x = [x ones(1, count(i))*i];
  end
end
% jumble up the results
x = x(:, randperm(n));
