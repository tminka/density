function z = gaussian_embedding(x, means, width)
% Returns z(i, j) = normpdf(x(j), means(i), width)
% width is in std deviations.

d = rows(x);
for i = 1:length(means)
  z((i*d-d+1):(i*d), :) = normpdf(x, means(:, i), width);
end
