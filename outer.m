function c = outer(a, b)
% OUTER         Matrix of outer products.
% OUTER(A,B) returns a matrix where each column is vec(a(:,i)*b(:,i)')
% or equivalently kron(b(:,i),a(:,i)).
% A and B must have the same number of columns.
%
% Example:
%   reshape(outer((1:3)',(1:2)'),3,2)

if rows(a) == 1
  c = a.*b;
else
  c = zeros(rows(a)*rows(b), cols(a));
  for i = 1:cols(a)
    c(:,i) = kron(b(:,i), a(:,i));
  end
end
