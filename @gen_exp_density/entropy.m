function h = entropy(obj)

h = -log(obj.b/2/obj.c) + gammaln(1/obj.b) + 1/obj.b;
