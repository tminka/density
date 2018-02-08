function obj = set_constraint(obj, L, lambda)

obj.L = L;
obj.lambda = lambda;
obj.icov = eye(rows(L)/length(obj.weights));
