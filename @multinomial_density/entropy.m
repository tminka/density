function h = entropy(obj)

h = -sum(obj.p.*log(obj.p+eps));
