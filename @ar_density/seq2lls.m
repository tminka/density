function data = seq2lls(obj, x)
% Returns a matrix of shifts of the sequence, suitable for training an
% lls density.

k = obj.degree;
data = x(:, 1:(cols(x) - k));
for i = 1:k
  data = [data; x((i+1):(cols(x) - k + i))];
end
