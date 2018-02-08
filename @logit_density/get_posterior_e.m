function density = get_posterior_e(obj)

e = obj.e;
g = gradient_e(obj, obj.data);
h = likelihood_hessian_e(obj, obj.data);

a = (g - h*(1-e))*e^2 + 1;
b = -(g + h*e)*(1-e)^2 + 1;
if a <= 0
  a = 1e-4;
end
if b <= 0
  b = 1e-4;
end
density = dirichlet_density([a;b]);
